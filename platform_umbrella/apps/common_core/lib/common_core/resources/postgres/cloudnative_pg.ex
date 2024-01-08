defmodule CommonCore.Resources.CloudnativePG do
  @moduledoc false
  use CommonCore.IncludeResource,
    backups_postgresql_cnpg_io: "priv/manifests/cloudnative-pg/backups_postgresql_cnpg_io.yaml",
    clusters_postgresql_cnpg_io: "priv/manifests/cloudnative-pg/clusters_postgresql_cnpg_io.yaml",
    poolers_postgresql_cnpg_io: "priv/manifests/cloudnative-pg/poolers_postgresql_cnpg_io.yaml",
    scheduledbackups_postgresql_cnpg_io: "priv/manifests/cloudnative-pg/scheduledbackups_postgresql_cnpg_io.yaml",
    queries: "priv/raw_files/cloudnative-pg/queries.yaml"

  use CommonCore.Resources.ResourceGenerator, app_name: "cloudnative-pg"

  import CommonCore.StateSummary.Namespaces

  alias CommonCore.Resources.Builder, as: B
  alias CommonCore.Resources.FilterResource, as: F

  resource(:cluster_role_binding_cloudnative_pg, _battery, state) do
    namespace = core_namespace(state)

    :cluster_role_binding
    |> B.build_resource()
    |> B.name("cloudnative-pg")
    |> B.role_ref(B.build_cluster_role_ref("cloudnative-pg"))
    |> B.subject(B.build_service_account("cloudnative-pg", namespace))
  end

  resource(:cluster_role_cloudnative_pg) do
    rules = [
      %{
        "apiGroups" => [""],
        "resources" => ["configmaps"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{"apiGroups" => [""], "resources" => ["configmaps/status"], "verbs" => ["get", "patch", "update"]},
      %{"apiGroups" => [""], "resources" => ["events"], "verbs" => ["create", "patch"]},
      %{"apiGroups" => [""], "resources" => ["namespaces"], "verbs" => ["get", "list", "watch"]},
      %{"apiGroups" => [""], "resources" => ["nodes"], "verbs" => ["get", "list", "watch"]},
      %{
        "apiGroups" => [""],
        "resources" => ["persistentvolumeclaims"],
        "verbs" => ["create", "delete", "get", "list", "patch", "watch"]
      },
      %{"apiGroups" => [""], "resources" => ["pods"], "verbs" => ["create", "delete", "get", "list", "patch", "watch"]},
      %{
        "apiGroups" => [""],
        "resources" => ["pods/exec"],
        "verbs" => ["create", "delete", "get", "list", "patch", "watch"]
      },
      %{"apiGroups" => [""], "resources" => ["pods/status"], "verbs" => ["get"]},
      %{
        "apiGroups" => [""],
        "resources" => ["secrets"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{"apiGroups" => [""], "resources" => ["secrets/status"], "verbs" => ["get", "patch", "update"]},
      %{
        "apiGroups" => [""],
        "resources" => ["serviceaccounts"],
        "verbs" => ["create", "get", "list", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => [""],
        "resources" => ["services"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => ["admissionregistration.k8s.io"],
        "resources" => ["mutatingwebhookconfigurations"],
        "verbs" => ["get", "list", "patch", "update"]
      },
      %{
        "apiGroups" => ["admissionregistration.k8s.io"],
        "resources" => ["validatingwebhookconfigurations"],
        "verbs" => ["get", "list", "patch", "update"]
      },
      %{
        "apiGroups" => ["apiextensions.k8s.io"],
        "resources" => ["customresourcedefinitions"],
        "verbs" => ["get", "list", "update"]
      },
      %{
        "apiGroups" => ["apps"],
        "resources" => ["deployments"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => ["batch"],
        "resources" => ["jobs"],
        "verbs" => ["create", "delete", "get", "list", "patch", "watch"]
      },
      %{"apiGroups" => ["coordination.k8s.io"], "resources" => ["leases"], "verbs" => ["create", "get", "update"]},
      %{
        "apiGroups" => ["monitoring.coreos.com"],
        "resources" => ["podmonitors"],
        "verbs" => ["create", "delete", "get", "list", "patch", "watch"]
      },
      %{
        "apiGroups" => ["policy"],
        "resources" => ["poddisruptionbudgets"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => ["postgresql.cnpg.io"],
        "resources" => ["backups"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{"apiGroups" => ["postgresql.cnpg.io"], "resources" => ["backups/status"], "verbs" => ["get", "patch", "update"]},
      %{
        "apiGroups" => ["postgresql.cnpg.io"],
        "resources" => ["clusters"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{"apiGroups" => ["postgresql.cnpg.io"], "resources" => ["clusters/finalizers"], "verbs" => ["update"]},
      %{
        "apiGroups" => ["postgresql.cnpg.io"],
        "resources" => ["clusters/status"],
        "verbs" => ["get", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => ["postgresql.cnpg.io"],
        "resources" => ["poolers"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{"apiGroups" => ["postgresql.cnpg.io"], "resources" => ["poolers/finalizers"], "verbs" => ["update"]},
      %{
        "apiGroups" => ["postgresql.cnpg.io"],
        "resources" => ["poolers/status"],
        "verbs" => ["get", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => ["postgresql.cnpg.io"],
        "resources" => ["scheduledbackups"],
        "verbs" => ["create", "delete", "get", "list", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => ["postgresql.cnpg.io"],
        "resources" => ["scheduledbackups/status"],
        "verbs" => ["get", "patch", "update"]
      },
      %{
        "apiGroups" => ["rbac.authorization.k8s.io"],
        "resources" => ["rolebindings"],
        "verbs" => ["create", "get", "list", "patch", "update", "watch"]
      },
      %{
        "apiGroups" => ["rbac.authorization.k8s.io"],
        "resources" => ["roles"],
        "verbs" => ["create", "get", "list", "patch", "update", "watch"]
      }
    ]

    :cluster_role |> B.build_resource() |> B.name("cloudnative-pg") |> B.rules(rules)
  end

  resource(:config_map_cnpg_controller_manager, _battery, state) do
    namespace = core_namespace(state)
    data = %{INHERITED_LABELS: "battery/app, battery/owner, app, app.kubernetes.io/name"}

    :config_map
    |> B.build_resource()
    |> B.name("cnpg-controller-manager-config")
    |> B.namespace(namespace)
    |> B.data(data)
  end

  resource(:config_map_cnpg_default_monitoring, _battery, state) do
    namespace = core_namespace(state)
    data = Map.put(%{}, "queries", get_resource(:queries))

    :config_map
    |> B.build_resource()
    |> B.name("cnpg-default-monitoring")
    |> B.namespace(namespace)
    |> B.data(data)
  end

  resource(:crd_backups_postgresql_cnpg_io) do
    YamlElixir.read_all_from_string!(get_resource(:backups_postgresql_cnpg_io))
  end

  resource(:crd_clusters_postgresql_cnpg_io) do
    YamlElixir.read_all_from_string!(get_resource(:clusters_postgresql_cnpg_io))
  end

  resource(:crd_poolers_postgresql_cnpg_io) do
    YamlElixir.read_all_from_string!(get_resource(:poolers_postgresql_cnpg_io))
  end

  resource(:crd_scheduledbackups_postgresql_cnpg_io) do
    YamlElixir.read_all_from_string!(get_resource(:scheduledbackups_postgresql_cnpg_io))
  end

  resource(:deployment_cloudnative_pg, battery, state) do
    namespace = core_namespace(state)

    template =
      %{
        "metadata" => %{"labels" => %{"battery/managed" => "true"}},
        "spec" => %{
          "containers" => [
            %{
              "args" => [
                "controller",
                "--leader-elect",
                "--config-map-name=cnpg-controller-manager-config",
                "--secret-name=cnpg-controller-manager-config",
                "--webhook-port=9443"
              ],
              "command" => ["/manager"],
              "env" => [
                %{"name" => "OPERATOR_IMAGE_NAME", "value" => battery.config.image},
                %{
                  "name" => "OPERATOR_NAMESPACE",
                  "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.namespace"}}
                },
                %{"name" => "MONITORING_QUERIES_CONFIGMAP", "value" => "cnpg-default-monitoring"}
              ],
              "image" => battery.config.image,
              "imagePullPolicy" => "IfNotPresent",
              "livenessProbe" => %{
                "httpGet" => %{"path" => "/readyz", "port" => 9443, "scheme" => "HTTPS"},
                "initialDelaySeconds" => 3
              },
              "name" => "manager",
              "ports" => [
                %{"containerPort" => 8080, "name" => "metrics", "protocol" => "TCP"},
                %{"containerPort" => 9443, "name" => "webhook-server", "protocol" => "TCP"}
              ],
              "readinessProbe" => %{
                "httpGet" => %{"path" => "/readyz", "port" => 9443, "scheme" => "HTTPS"},
                "initialDelaySeconds" => 3
              },
              "resources" => %{},
              "securityContext" => %{
                "allowPrivilegeEscalation" => false,
                "capabilities" => %{"drop" => ["ALL"]},
                "readOnlyRootFilesystem" => true,
                "runAsGroup" => 10_001,
                "runAsUser" => 10_001
              },
              "volumeMounts" => [
                %{"mountPath" => "/controller", "name" => "scratch-data"},
                %{"mountPath" => "/run/secrets/cnpg.io/webhook", "name" => "webhook-certificates"}
              ]
            }
          ],
          "securityContext" => %{"runAsNonRoot" => true, "seccompProfile" => %{"type" => "RuntimeDefault"}},
          "serviceAccountName" => "cloudnative-pg",
          "terminationGracePeriodSeconds" => 10,
          "volumes" => [
            %{"emptyDir" => %{}, "name" => "scratch-data"},
            %{
              "name" => "webhook-certificates",
              "secret" => %{"defaultMode" => 420, "optional" => true, "secretName" => "cnpg-webhook-cert"}
            }
          ]
        }
      }
      |> B.app_labels(@app_name)
      |> B.add_owner(battery)

    spec =
      %{}
      |> Map.put("replicas", 1)
      |> Map.put("selector", %{"matchLabels" => %{"battery/app" => @app_name}})
      |> B.template(template)

    :deployment
    |> B.build_resource()
    |> B.name("cloudnative-pg")
    |> B.namespace(namespace)
    |> B.spec(spec)
  end

  resource(:monitoring_pod_monitor_cloudnative_pg, _battery, state) do
    namespace = core_namespace(state)

    spec =
      %{}
      |> Map.put("podMetricsEndpoints", [%{"port" => "metrics"}])
      |> Map.put(
        "selector",
        %{"matchLabels" => %{"battery/app" => @app_name}}
      )

    :monitoring_pod_monitor
    |> B.build_resource()
    |> B.name("cloudnative-pg")
    |> B.namespace(namespace)
    |> B.spec(spec)
    |> F.require_battery(state, :victoria_metrics)
  end

  resource(:mutating_webhook_config_cnpg_configuration) do
    :mutating_webhook_config
    |> B.build_resource()
    |> B.name("cnpg-mutating-webhook-configuration")
    |> Map.put("webhooks", [
      %{
        "admissionReviewVersions" => ["v1"],
        "clientConfig" => %{
          "service" => %{
            "name" => "cnpg-webhook-service",
            "namespace" => "battery-core",
            "path" => "/mutate-postgresql-cnpg-io-v1-backup",
            "port" => 443
          }
        },
        "failurePolicy" => "Fail",
        "name" => "mbackup.kb.io",
        "rules" => [
          %{
            "apiGroups" => ["postgresql.cnpg.io"],
            "apiVersions" => ["v1"],
            "operations" => ["CREATE", "UPDATE"],
            "resources" => ["backups"]
          }
        ],
        "sideEffects" => "None"
      },
      %{
        "admissionReviewVersions" => ["v1"],
        "clientConfig" => %{
          "service" => %{
            "name" => "cnpg-webhook-service",
            "namespace" => "battery-core",
            "path" => "/mutate-postgresql-cnpg-io-v1-cluster",
            "port" => 443
          }
        },
        "failurePolicy" => "Fail",
        "name" => "mcluster.kb.io",
        "rules" => [
          %{
            "apiGroups" => ["postgresql.cnpg.io"],
            "apiVersions" => ["v1"],
            "operations" => ["CREATE", "UPDATE"],
            "resources" => ["clusters"]
          }
        ],
        "sideEffects" => "None"
      },
      %{
        "admissionReviewVersions" => ["v1"],
        "clientConfig" => %{
          "service" => %{
            "name" => "cnpg-webhook-service",
            "namespace" => "battery-core",
            "path" => "/mutate-postgresql-cnpg-io-v1-scheduledbackup",
            "port" => 443
          }
        },
        "failurePolicy" => "Fail",
        "name" => "mscheduledbackup.kb.io",
        "rules" => [
          %{
            "apiGroups" => ["postgresql.cnpg.io"],
            "apiVersions" => ["v1"],
            "operations" => ["CREATE", "UPDATE"],
            "resources" => ["scheduledbackups"]
          }
        ],
        "sideEffects" => "None"
      }
    ])
  end

  resource(:service_account_cloudnative_pg, _battery, state) do
    namespace = core_namespace(state)

    :service_account
    |> B.build_resource()
    |> B.name("cloudnative-pg")
    |> B.namespace(namespace)
  end

  resource(:service_cnpg_webhook, _battery, state) do
    namespace = core_namespace(state)

    spec =
      %{}
      |> Map.put("ports", [
        %{"name" => "webhook-server", "port" => 443, "targetPort" => "webhook-server"}
      ])
      |> Map.put("selector", %{"battery/app" => @app_name})

    :service
    |> B.build_resource()
    |> B.name("cnpg-webhook-service")
    |> B.namespace(namespace)
    |> B.spec(spec)
  end

  resource(:validating_webhook_config_cnpg_configuration) do
    :validating_webhook_config
    |> B.build_resource()
    |> B.name("cnpg-validating-webhook-configuration")
    |> Map.put("webhooks", [
      %{
        "admissionReviewVersions" => ["v1"],
        "clientConfig" => %{
          "service" => %{
            "name" => "cnpg-webhook-service",
            "namespace" => "battery-core",
            "path" => "/validate-postgresql-cnpg-io-v1-backup",
            "port" => 443
          }
        },
        "failurePolicy" => "Fail",
        "name" => "vbackup.kb.io",
        "rules" => [
          %{
            "apiGroups" => ["postgresql.cnpg.io"],
            "apiVersions" => ["v1"],
            "operations" => ["CREATE", "UPDATE"],
            "resources" => ["backups"]
          }
        ],
        "sideEffects" => "None"
      },
      %{
        "admissionReviewVersions" => ["v1"],
        "clientConfig" => %{
          "service" => %{
            "name" => "cnpg-webhook-service",
            "namespace" => "battery-core",
            "path" => "/validate-postgresql-cnpg-io-v1-cluster",
            "port" => 443
          }
        },
        "failurePolicy" => "Fail",
        "name" => "vcluster.kb.io",
        "rules" => [
          %{
            "apiGroups" => ["postgresql.cnpg.io"],
            "apiVersions" => ["v1"],
            "operations" => ["CREATE", "UPDATE"],
            "resources" => ["clusters"]
          }
        ],
        "sideEffects" => "None"
      },
      %{
        "admissionReviewVersions" => ["v1"],
        "clientConfig" => %{
          "service" => %{
            "name" => "cnpg-webhook-service",
            "namespace" => "battery-core",
            "path" => "/validate-postgresql-cnpg-io-v1-scheduledbackup",
            "port" => 443
          }
        },
        "failurePolicy" => "Fail",
        "name" => "vscheduledbackup.kb.io",
        "rules" => [
          %{
            "apiGroups" => ["postgresql.cnpg.io"],
            "apiVersions" => ["v1"],
            "operations" => ["CREATE", "UPDATE"],
            "resources" => ["scheduledbackups"]
          }
        ],
        "sideEffects" => "None"
      },
      %{
        "admissionReviewVersions" => ["v1"],
        "clientConfig" => %{
          "service" => %{
            "name" => "cnpg-webhook-service",
            "namespace" => "battery-core",
            "path" => "/validate-postgresql-cnpg-io-v1-pooler",
            "port" => 443
          }
        },
        "failurePolicy" => "Fail",
        "name" => "vpooler.kb.io",
        "rules" => [
          %{
            "apiGroups" => ["postgresql.cnpg.io"],
            "apiVersions" => ["v1"],
            "operations" => ["CREATE", "UPDATE"],
            "resources" => ["poolers"]
          }
        ],
        "sideEffects" => "None"
      }
    ])
  end
end
