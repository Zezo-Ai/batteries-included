#!/bin/bash
set -xuo pipefail

# Grab the location we'll use it for yaml locations soon
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]]; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}

trap 'error ${LINENO} Trap:' ERR
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

retry() {
  local n=1
  local max=10
  local delay=30
  local start=`date +%s`

  while true; do
    start=`date +%s`
    "$@" && break || {
      local code=$?
      local end=`date +%s`
      local runtime=$((end-start))
      if [[ $n -lt $max ]]; then
        # Explicitly treat timeouts as not failures.
        if [[ $runtime -gt 200 ]]; then
          echo "Looks command timed out. Not counting it"
        else
          ((n++))
          echo "Failed. $n/$max"
          sleep $delay
        fi
      else
        error ${LINENO} "The command has failed after $n attempts."
      fi
    }
  done
}

portForward() {
  local target=$1
  local portMap=$2
  local namespace=$3

  if kubectl get ns "${namespace}"; then

    set +e
    kubectl port-forward "${target}" ${portMap} -n "$namespace" --address 0.0.0.0
    local code=$?
    set -e
    echo "Exited"
    return 1
  else
    return 0
  fi
}

postgresForward() {
  local cluster=$1
  local port=$2
  local ns=${3:-"battery-core"}
  local pod=$(kubectl \
            get pods \
            -o jsonpath={.items..metadata.name} \
            -n ${ns} -l application=spilo \
            -l battery-cluster-name=${cluster} \
            -l spilo-role=master)
  portForward "pods/${pod}" "${port}:5432" ${ns}
}

buildLocalControl() {
  ${DIR}/build_local.sh
}

cargoBootstrap() {
  pushd ${DIR}/../rust_utils
  cargo run -- bootstrap || true
  popd
}

mixBootstrap() {
  pushd ${DIR}/../platform_umbrella/apps/bootstrap
  mix run -e "Bootstrap.InitialSync.run()"
  popd
}

CREATE_CLUSTER=${CREATE_CLUSTER:-true}
FORWARD_CONTROL_POSTGRES=${FORWARD_CONTROL_POSTGRES:-true}
FORWARD_HOME_POSTGRES=${FORWARD_HOME_POSTGRES:-false}
BUILD_CONTROL_SERVER=${BUILD_CONTROL_SERVER:-false}

PARAMS=""
while (("$#")); do
  case "$1" in
  -c | --create-cluster)
    CREATE_CLUSTER=true
    shift
    ;;

  -e | --forward-external)
    FORWARD_EXTERNAL_POSTGRES=true
    shift
    ;;

  -b | --forward-home-base)
    FORWARD_HOME_POSTGRES=true
    shift
    ;;
  -B | --build-local)
    BUILD_CONTROL_SERVER=true
    shift
    ;;
  -* | --*=) # unsupported flags
    echo "Error: Unsupported flag $1" >&2
    exit 1
    ;;
  *) # preserve positional arguments
    PARAMS="$PARAMS $1"
    shift
    ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [[ $CREATE_CLUSTER == 'true' ]]; then
  # Create the cluster
  k3d cluster create -v /dev/mapper:/dev/mapper \
    --k3s-server-arg '--no-deploy=traefik' \
    --registry-create --wait \
    -p "8081:80@loadbalancer" || true
fi

cargoBootstrap
mixBootstrap

if [ $BUILD_CONTROL_SERVER == "true" ]; then
  buildLocalControl
fi

if [ $FORWARD_CONTROL_POSTGRES == "true" ]; then
  (retry postgresForward "default-control" "5432") &
fi

if [[ $FORWARD_HOME_POSTGRES == "true" ]]; then
  (retry postgresForward "default-home-base" "5433") &
fi

wait
