defmodule ControlServer.Services.Battery do
  @moduledoc false

  alias ControlServer.Settings.BatterySettings

  defp namespace(config) do
    ns = BatterySettings.namespace(config)

    %{
      "apiVersion" => "v1",
      "kind" => "Namespace",
      "metadata" => %{
        "name" => ns
      }
    }
  end

  def deployment_0(config) do
    namespace = BatterySettings.namespace(config)
    name = BatterySettings.control_server_name(config)

    %{
      "apiVersion" => "apps/v1",
      "kind" => "Deployment",
      "metadata" => %{
        "labels" => %{"battery-managed" => "True", "k8s-app" => name},
        "name" => name,
        "namespace" => namespace
      },
      "spec" => %{
        "replicas" => 1,
        "selector" => %{
          "matchLabels" => %{"k8s-app" => name}
        },
        "template" => %{
          "metadata" => %{
            "labels" => %{"battery-managed" => "True", "k8s-app" => name}
          },
          "spec" => %{
            "initContainers" => [
              control_container(config,
                name: "migrate",
                base: %{"command" => ["bin/control_server_migrate"]}
              )
            ],
            "containers" => [
              control_container(config,
                name: name,
                base: %{
                  "command" => ["bin/control_server"],
                  "ports" => [%{"containerPort" => 4000}]
                }
              )
            ],
            "serviceAccountName" => "control-server-account"
          }
        }
      }
    }
  end

  defp control_container(config, options) do
    base = Keyword.get(options, :base, %{})
    name = Keyword.get(options, :name, BatterySettings.control_server_name(config))
    version = Keyword.get(options, :version, BatterySettings.control_server_version(config))
    image = Keyword.get(options, :image, BatterySettings.control_server_image(config))

    env = [
      %{
        "name" => "POSTGRES_HOST",
        "value" => "postgres.default.svc.cluster.local"
      },
      %{
        "name" => "POSTGRES_DB",
        "value" => "control-dev"
      },
      %{
        "name" => "SECRET_KEY_BASE",
        "value" => "TEST_ING"
      },
      %{
        "name" => "POSTGRES_USER",
        "value" => "batterydbuser"
      },
      %{"name" => "MIX_ENV", "value" => "prod"},
      %{
        "name" => "BONNY_POD_NAME",
        "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.name"}}
      },
      %{
        "name" => "BONNY_POD_NAMESPACE",
        "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.namespace"}}
      },
      %{
        "name" => "BONNY_POD_IP",
        "valueFrom" => %{"fieldRef" => %{"fieldPath" => "status.podIP"}}
      },
      %{
        "name" => "BONNY_POD_SERVICE_ACCOUNT",
        "valueFrom" => %{"fieldRef" => %{"fieldPath" => "spec.serviceAccountName"}}
      }
    ]

    Map.merge(
      base,
      %{
        "name" => name,
        "env" => env,
        "image" => "#{image}:#{version}",
        "resources" => %{
          "limits" => %{"cpu" => "200m", "memory" => "200Mi"},
          "requests" => %{"cpu" => "200m", "memory" => "200Mi"}
        },
        "securityContext" => %{
          "allowPrivilegeEscalation" => false,
          "readOnlyRootFilesystem" => true,
          "runAsNonRoot" => true,
          "runAsUser" => 65_534
        }
      }
    )
  end

  def cluster_role_0(_config) do
    %{
      "apiVersion" => "rbac.authorization.k8s.io/v1",
      "kind" => "ClusterRole",
      "metadata" => %{
        "labels" => %{"battery-managed" => "True", "k8s-app" => "control-server"},
        "name" => "control-server-account"
      },
      "rules" => [
        %{
          "apiGroups" => ["apiextensions.k8s.io"],
          "resources" => ["customresourcedefinitions"],
          "verbs" => ["*"]
        },
        %{
          "apiGroups" => ["k8s.batteriesincl.com"],
          "resources" => ["batteryclusters"],
          "verbs" => ["*"]
        },
        %{
          "apiGroups" => [""],
          "resources" => [
            "secrets",
            "pods",
            "configmap",
            "deployment",
            "serviceaccounts",
            "service",
            "events"
          ],
          "verbs" => ["*"]
        },
        %{
          "apiGroups" => ["apiextensions.k8s.io"],
          "resources" => ["customresourcedefinitions"],
          "verbs" => ["*"]
        },
        %{
          "apiGroups" => ["apps"],
          "resources" => ["deployment", "statefulsets"],
          "verbs" => ["*"]
        },
        %{"apiGroups" => ["batch"], "resources" => ["job"], "verbs" => ["*"]},
        %{
          "apiGroups" => ["rbac.authorization.k8s.io"],
          "resources" => ["clusterroles", "clusterrolebindings"],
          "verbs" => ["*"]
        }
      ]
    }
  end

  def service_account_0(config) do
    namespace = BatterySettings.namespace(config)

    %{
      "apiVersion" => "v1",
      "kind" => "ServiceAccount",
      "metadata" => %{
        "labels" => %{"battery-managed" => "True", "k8s-app" => "control-server"},
        "name" => "control-server-account",
        "namespace" => namespace
      }
    }
  end

  def cluster_role_binding_0(config) do
    namespace = BatterySettings.namespace(config)

    %{
      "apiVersion" => "rbac.authorization.k8s.io/v1",
      "kind" => "ClusterRoleBinding",
      "metadata" => %{
        "labels" => %{"battery-managed" => "True", "k8s-app" => "control-server"},
        "name" => "control-server-account"
      },
      "roleRef" => %{
        "apiGroup" => "rbac.authorization.k8s.io",
        "kind" => "ClusterRole",
        "name" => "control-server-account"
      },
      "subjects" => [
        %{
          "kind" => "ServiceAccount",
          "name" => "control-server-account",
          "namespace" => namespace
        }
      ]
    }
  end

  def materialize(config) do
    %{
      "/0/namespace" => namespace(config),
      "/1/cluster_role_0" => cluster_role_0(config),
      "/2/service_account_0" => service_account_0(config),
      "/3/cluster_role_binding_0" => cluster_role_binding_0(config),
      "/4/deployment_0" => deployment_0(config)
    }
  end
end
