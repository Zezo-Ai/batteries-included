defmodule CommonCore.Resources.Bootstrap.BatteryCore do
  @moduledoc false

  # Use the same app_name so that core_namespace
  # is labeled  with the same app_name as the other namespaces
  use CommonCore.Resources.ResourceGenerator, app_name: "battery-core"

  import CommonCore.Resources.StorageClass

  alias CommonCore.Resources.Builder, as: B
  alias CommonCore.Resources.FilterResource, as: F

  resource(:core_namespace, battery, _state) do
    :namespace
    |> B.build_resource()
    |> B.name(battery.config.core_namespace)
    |> B.label("istio-injection", "enabled")
  end

  multi_resource(:storage_class, battery) do
    Enum.filter(generate_eks_storage_classes(), fn sc ->
      F.require(sc, battery.config.cluster_type == :aws)
    end)
  end

  resource(:bootstrap_service_account, battery) do
    namespace = battery.config.core_namespace

    :service_account
    |> B.build_resource()
    |> B.name("bootstrap")
    |> B.namespace(namespace)
    |> F.require(battery.config.server_in_cluster)
  end

  resource(:bootstrap_clusterrolebinding, battery) do
    namespace = battery.config.core_namespace

    :cluster_role_binding
    |> B.build_resource()
    |> B.name("batteries-included:bootstrap")
    |> B.role_ref(B.build_cluster_role_ref("cluster-admin"))
    |> B.subject(B.build_service_account("bootstrap", namespace))
    |> F.require(battery.config.server_in_cluster)
  end

  resource(:boostrap_job, battery) do
    namespace = battery.config.core_namespace

    bootstrap_summary_root = "/var/run/secrets/summary"

    spec = %{
      "backoffLimit" => 4,
      "completions" => 1,
      "parallelism" => 1,
      "template" => %{
        "metadata" => %{"labels" => %{"battery/app" => "bootstrap"}},
        "spec" => %{
          "automountServiceAccountToken" => true,
          "containers" => [
            %{
              "env" => [
                %{"name" => "RELEASE_COOKIE", "value" => battery.config.secret_key},
                %{"name" => "RELEASE_DISTRIBUTION", "value" => "none"},
                %{"name" => "BOOTSTRAP_SUMMARY_PATH", "value" => "#{bootstrap_summary_root}/summary.json"}
              ],
              "image" => battery.config.bootstrap_image,
              "name" => "bootstrap",
              "volumeMounts" => [%{"mountPath" => bootstrap_summary_root, "name" => "summary"}]
            }
          ],
          "restartPolicy" => "Never",
          "serviceAccount" => "bootstrap",
          "serviceAccountName" => "bootstrap",
          "tolerations" => [%{"key" => "CriticalAddonsOnly", "operator" => "Exists"}],
          "volumes" => [%{"name" => "summary", "secret" => %{"secretName" => "initial-target-summary"}}]
        }
      }
    }

    :job
    |> B.build_resource()
    |> B.name("bootstrap")
    |> B.namespace(namespace)
    |> B.spec(spec)
    |> F.require(battery.config.server_in_cluster)
  end
end
