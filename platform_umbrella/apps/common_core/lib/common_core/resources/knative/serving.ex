defmodule CommonCore.Resources.KnativeServing do
  @moduledoc false
  use CommonCore.Resources.ResourceGenerator, app_name: "knative-serving"

  import CommonCore.StateSummary.Hosts

  alias CommonCore.Resources.Builder, as: B
  alias CommonCore.Resources.Secret

  resource(:cluster_role_binding_activator, battery, _state) do
    :cluster_role_binding
    |> B.build_resource()
    |> B.name("knative-serving-activator-cluster")
    |> B.component_label("activator")
    |> B.role_ref(B.build_cluster_role_ref("knative-serving-activator-cluster"))
    |> B.subject(B.build_service_account("activator", battery.config.namespace))
  end

  resource(
    :cluster_role_binding_controller_addressable_resolver,
    battery,
    _state
  ) do
    :cluster_role_binding
    |> B.build_resource()
    |> B.name("knative-serving-controller-addressable-resolver")
    |> B.component_label("controller")
    |> B.role_ref(B.build_cluster_role_ref("knative-serving-aggregated-addressable-resolver"))
    |> B.subject(B.build_service_account("controller", battery.config.namespace))
  end

  resource(:cluster_role_binding_controller_admin, battery, _state) do
    :cluster_role_binding
    |> B.build_resource()
    |> B.name("knative-serving-controller-admin")
    |> B.component_label("controller")
    |> B.role_ref(B.build_cluster_role_ref("knative-serving-admin"))
    |> B.subject(B.build_service_account("controller", battery.config.namespace))
  end

  resource(:cluster_role_activator) do
    rules = [
      %{"apiGroups" => [""], "resources" => ["services", "endpoints"], "verbs" => ["get", "list", "watch"]},
      %{"apiGroups" => ["serving.knative.dev"], "resources" => ["revisions"], "verbs" => ["get", "list", "watch"]}
    ]

    :cluster_role
    |> B.build_resource()
    |> B.name("knative-serving-activator-cluster")
    |> B.label("serving.knative.dev/controller", "true")
    |> B.rules(rules)
  end

  resource(:cluster_role_addressable_resolver) do
    rules = [
      %{
        "apiGroups" => ["serving.knative.dev"],
        "resources" => ["routes", "routes/status", "services", "services/status"],
        "verbs" => ["get", "list", "watch"]
      }
    ]

    :cluster_role
    |> B.build_resource()
    |> B.name("knative-serving-addressable-resolver")
    |> B.label("duck.knative.dev/addressable", "true")
    |> B.rules(rules)
  end

  resource(:cluster_role_admin, _battery, _state) do
    :cluster_role
    |> B.build_resource()
    |> B.aggregation_rule(%{"clusterRoleSelectors" => [%{"matchLabels" => %{"serving.knative.dev/controller" => "true"}}]})
    |> B.name("knative-serving-admin")
  end

  resource(:cluster_role_aggregated_addressable_resolver, _battery, _state) do
    :cluster_role
    |> B.build_resource()
    |> B.aggregation_rule(%{"clusterRoleSelectors" => [%{"matchLabels" => %{"duck.knative.dev/addressable" => "true"}}]})
    |> B.name("knative-serving-aggregated-addressable-resolver")
  end

  resource(:cluster_role_core) do
    rules = [
      %{
        "apiGroups" => [""],
        "resources" => [
          "pods",
          "namespaces",
          "secrets",
          "configmaps",
          "endpoints",
          "services",
          "events",
          "serviceaccounts"
        ],
        "verbs" => ["get", "list", "create", "update", "delete", "patch", "watch"]
      },
      %{"apiGroups" => [""], "resources" => ["endpoints/restricted"], "verbs" => ["create"]},
      %{"apiGroups" => [""], "resources" => ["namespaces/finalizers"], "verbs" => ["update"]},
      %{
        "apiGroups" => ["apps"],
        "resources" => ["deployments", "deployments/finalizers"],
        "verbs" => ["get", "list", "create", "update", "delete", "patch", "watch"]
      },
      %{
        "apiGroups" => ["admissionregistration.k8s.io"],
        "resources" => ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"],
        "verbs" => ["get", "list", "create", "update", "delete", "patch", "watch"]
      },
      %{
        "apiGroups" => ["apiextensions.k8s.io"],
        "resources" => ["customresourcedefinitions", "customresourcedefinitions/status"],
        "verbs" => ["get", "list", "create", "update", "delete", "patch", "watch"]
      },
      %{
        "apiGroups" => ["autoscaling"],
        "resources" => ["horizontalpodautoscalers"],
        "verbs" => ["get", "list", "create", "update", "delete", "patch", "watch"]
      },
      %{
        "apiGroups" => ["coordination.k8s.io"],
        "resources" => ["leases"],
        "verbs" => ["get", "list", "create", "update", "delete", "patch", "watch"]
      },
      %{
        "apiGroups" => ["serving.knative.dev", "autoscaling.internal.knative.dev", "networking.internal.knative.dev"],
        "resources" => ["*", "*/status", "*/finalizers"],
        "verbs" => ["get", "list", "create", "update", "delete", "deletecollection", "patch", "watch"]
      },
      %{
        "apiGroups" => ["caching.internal.knative.dev"],
        "resources" => ["images"],
        "verbs" => ["get", "list", "create", "update", "delete", "patch", "watch"]
      }
    ]

    :cluster_role
    |> B.build_resource()
    |> B.name("knative-serving-core")
    |> B.label("serving.knative.dev/controller", "true")
    |> B.rules(rules)
  end

  resource(:cluster_role_namespaced_admin) do
    rules = [
      %{"apiGroups" => ["serving.knative.dev"], "resources" => ["*"], "verbs" => ["*"]},
      %{
        "apiGroups" => [
          "networking.internal.knative.dev",
          "autoscaling.internal.knative.dev",
          "caching.internal.knative.dev"
        ],
        "resources" => ["*"],
        "verbs" => ["get", "list", "watch"]
      }
    ]

    :cluster_role
    |> B.build_resource()
    |> B.name("knative-serving-namespaced-admin")
    |> B.label("rbac.authorization.k8s.io/aggregate-to-admin", "true")
    |> B.rules(rules)
  end

  resource(:cluster_role_namespaced_edit) do
    rules = [
      %{"apiGroups" => ["serving.knative.dev"], "resources" => ["*"], "verbs" => ["create", "update", "patch", "delete"]},
      %{
        "apiGroups" => [
          "networking.internal.knative.dev",
          "autoscaling.internal.knative.dev",
          "caching.internal.knative.dev"
        ],
        "resources" => ["*"],
        "verbs" => ["get", "list", "watch"]
      }
    ]

    :cluster_role
    |> B.build_resource()
    |> B.name("knative-serving-namespaced-edit")
    |> B.label("rbac.authorization.k8s.io/aggregate-to-edit", "true")
    |> B.rules(rules)
  end

  resource(:cluster_role_namespaced_view) do
    rules = [
      %{
        "apiGroups" => [
          "serving.knative.dev",
          "networking.internal.knative.dev",
          "autoscaling.internal.knative.dev",
          "caching.internal.knative.dev"
        ],
        "resources" => ["*"],
        "verbs" => ["get", "list", "watch"]
      }
    ]

    :cluster_role
    |> B.build_resource()
    |> B.name("knative-serving-namespaced-view")
    |> B.label("rbac.authorization.k8s.io/aggregate-to-view", "true")
    |> B.rules(rules)
  end

  resource(:cluster_role_podspecable_binding) do
    rules = [
      %{
        "apiGroups" => ["serving.knative.dev"],
        "resources" => ["configurations", "services"],
        "verbs" => ["list", "watch", "patch"]
      }
    ]

    :cluster_role
    |> B.build_resource()
    |> B.name("knative-serving-podspecable-binding")
    |> B.label("duck.knative.dev/podspecable", "true")
    |> B.rules(rules)
  end

  resource(:config_map_autoscaler, battery, _state) do
    data = %{}

    :config_map
    |> B.build_resource()
    |> B.name("config-autoscaler")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("autoscaler")
    |> B.data(data)
  end

  resource(:config_map_defaults, battery, _state) do
    data = %{}

    :config_map
    |> B.build_resource()
    |> B.name("config-defaults")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
    |> B.data(data)
  end

  resource(:config_map_deployment, battery, _state) do
    data =
      %{
        "queue-sidecar-image" =>
          "gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:739d6ce20e3a4eb646d47472163eca88df59bb637cad4d1e100de07a15fe63a2"
      }

    :config_map
    |> B.build_resource()
    |> B.name("config-deployment")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
    |> B.data(data)
  end

  resource(:config_map_domain, battery, state) do
    data = Map.put(%{}, knative_base_host(state), "")

    :config_map
    |> B.build_resource()
    |> B.name("config-domain")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
    |> B.data(data)
  end

  resource(:config_map_features, battery, _state) do
    data =
      %{}
      |> Map.put("multi-container", "enabled")
      |> Map.put("kubernetes.podspec-volumes-emptydir", "enabled")
      |> Map.put("kubernetes.podspec-init-containers", "enabled")

    :config_map
    |> B.build_resource()
    |> B.name("config-features")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
    |> B.data(data)
  end

  resource(:config_map_gc, battery, _state) do
    data = %{}

    :config_map
    |> B.build_resource()
    |> B.name("config-gc")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
    |> B.data(data)
  end

  resource(:config_map_leader_election, battery, _state) do
    data = %{}

    :config_map
    |> B.build_resource()
    |> B.name("config-leader-election")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
    |> B.data(data)
  end

  resource(:config_map_logging, battery, _state) do
    data = %{}

    :config_map
    |> B.build_resource()
    |> B.name("config-logging")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("logging")
    |> B.data(data)
  end

  resource(:config_map_network, battery, _state) do
    data = %{}

    :config_map
    |> B.build_resource()
    |> B.name("config-network")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("networking")
    |> B.data(data)
  end

  resource(:config_map_observability, battery, _state) do
    data = %{}

    :config_map
    |> B.build_resource()
    |> B.name("config-observability")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("observability")
    |> B.data(data)
  end

  resource(:config_map_tracing, battery, _state) do
    data = %{}

    :config_map
    |> B.build_resource()
    |> B.name("config-tracing")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("tracing")
    |> B.data(data)
  end

  resource(:deployment_activator, battery, _state) do
    template =
      %{
        "metadata" => %{
          "labels" => %{
            "battery/managed" => "true"
          }
        },
        "spec" => %{
          "containers" => [
            %{
              "env" => [
                %{"name" => "GOGC", "value" => "500"},
                %{"name" => "POD_NAME", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.name"}}},
                %{"name" => "POD_IP", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "status.podIP"}}},
                %{"name" => "SYSTEM_NAMESPACE", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.namespace"}}},
                %{"name" => "CONFIG_LOGGING_NAME", "value" => "config-logging"},
                %{"name" => "CONFIG_OBSERVABILITY_NAME", "value" => "config-observability"},
                %{"name" => "METRICS_DOMAIN", "value" => "knative.dev/internal/serving"}
              ],
              "image" =>
                "gcr.io/knative-releases/knative.dev/serving/cmd/activator@sha256:eff69d2271dde5f4ad0eb665d8a493773d7c78da05c2a5ef94c1d84dcac37cf1",
              "livenessProbe" => %{
                "failureThreshold" => 12,
                "httpGet" => %{
                  "httpHeaders" => [%{"name" => "k-kubelet-probe", "value" => "activator"}],
                  "port" => 8012
                },
                "initialDelaySeconds" => 15,
                "periodSeconds" => 10
              },
              "name" => "activator",
              "ports" => [
                %{"containerPort" => 9090, "name" => "metrics"},
                %{"containerPort" => 8008, "name" => "profiling"},
                %{"containerPort" => 8012, "name" => "http1"},
                %{"containerPort" => 8013, "name" => "h2c"}
              ],
              "readinessProbe" => %{
                "failureThreshold" => 5,
                "httpGet" => %{
                  "httpHeaders" => [%{"name" => "k-kubelet-probe", "value" => "activator"}],
                  "port" => 8012
                },
                "periodSeconds" => 5
              },
              "resources" => %{
                "limits" => %{"cpu" => "1000m", "memory" => "600Mi"},
                "requests" => %{"cpu" => "300m", "memory" => "60Mi"}
              },
              "securityContext" => %{
                "allowPrivilegeEscalation" => false,
                "capabilities" => %{"drop" => ["ALL"]},
                "readOnlyRootFilesystem" => true,
                "runAsNonRoot" => true,
                "seccompProfile" => %{"type" => "RuntimeDefault"}
              }
            }
          ],
          "serviceAccountName" => "activator",
          "terminationGracePeriodSeconds" => 600
        }
      }
      |> B.app_labels(@app_name)
      |> B.component_label("activator")

    spec =
      %{}
      |> Map.put(
        "selector",
        %{"matchLabels" => %{"battery/app" => @app_name, "battery/component" => "activator"}}
      )
      |> B.template(template)

    :deployment
    |> B.build_resource()
    |> B.name("activator")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("activator")
    |> B.spec(spec)
  end

  resource(:deployment_autoscaler, battery, _state) do
    template =
      %{
        "metadata" => %{
          "labels" => %{
            "battery/managed" => "true"
          }
        },
        "spec" => %{
          "affinity" => %{
            "podAntiAffinity" => %{
              "preferredDuringSchedulingIgnoredDuringExecution" => [
                %{
                  "podAffinityTerm" => %{
                    "labelSelector" => %{
                      "matchLabels" => %{"battery/app" => @app_name, "battery/component" => "autoscaler"}
                    },
                    "topologyKey" => "kubernetes.io/hostname"
                  },
                  "weight" => 100
                }
              ]
            }
          },
          "containers" => [
            %{
              "env" => [
                %{"name" => "POD_NAME", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.name"}}},
                %{"name" => "POD_IP", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "status.podIP"}}},
                %{"name" => "SYSTEM_NAMESPACE", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.namespace"}}},
                %{"name" => "CONFIG_LOGGING_NAME", "value" => "config-logging"},
                %{"name" => "CONFIG_OBSERVABILITY_NAME", "value" => "config-observability"},
                %{"name" => "METRICS_DOMAIN", "value" => "knative.dev/serving"}
              ],
              "image" =>
                "gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler@sha256:7908e2a3e2238d14044527f8f991cc76492e0de2110e2abef5e3ee4a59b43c4f",
              "livenessProbe" => %{
                "failureThreshold" => 6,
                "httpGet" => %{
                  "httpHeaders" => [%{"name" => "k-kubelet-probe", "value" => "autoscaler"}],
                  "port" => 8080
                }
              },
              "name" => "autoscaler",
              "ports" => [
                %{"containerPort" => 9090, "name" => "metrics"},
                %{"containerPort" => 8008, "name" => "profiling"},
                %{"containerPort" => 8080, "name" => "websocket"}
              ],
              "readinessProbe" => %{
                "httpGet" => %{
                  "httpHeaders" => [%{"name" => "k-kubelet-probe", "value" => "autoscaler"}],
                  "port" => 8080
                }
              },
              "resources" => %{
                "limits" => %{"cpu" => "1000m", "memory" => "1000Mi"},
                "requests" => %{"cpu" => "100m", "memory" => "100Mi"}
              },
              "securityContext" => %{
                "allowPrivilegeEscalation" => false,
                "capabilities" => %{"drop" => ["ALL"]},
                "readOnlyRootFilesystem" => true,
                "runAsNonRoot" => true,
                "seccompProfile" => %{"type" => "RuntimeDefault"}
              }
            }
          ],
          "serviceAccountName" => "controller"
        }
      }
      |> B.app_labels(@app_name)
      |> B.component_label("autoscaler")

    spec =
      %{}
      |> Map.put("replicas", 1)
      |> Map.put("selector", %{
        "matchLabels" => %{"battery/app" => @app_name, "battery/component" => "autoscaler"}
      })
      |> Map.put(
        "strategy",
        %{"rollingUpdate" => %{"maxUnavailable" => 0}, "type" => "RollingUpdate"}
      )
      |> B.template(template)

    :deployment
    |> B.build_resource()
    |> B.name("autoscaler")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("autoscaler")
    |> B.spec(spec)
  end

  resource(:deployment_controller, battery, _state) do
    template =
      %{
        "metadata" => %{
          "labels" => %{
            "battery/managed" => "true"
          }
        },
        "spec" => %{
          "affinity" => %{
            "podAntiAffinity" => %{
              "preferredDuringSchedulingIgnoredDuringExecution" => [
                %{
                  "podAffinityTerm" => %{
                    "labelSelector" => %{
                      "matchLabels" => %{"battery/app" => @app_name, "battery/component" => "controller"}
                    },
                    "topologyKey" => "kubernetes.io/hostname"
                  },
                  "weight" => 100
                }
              ]
            }
          },
          "containers" => [
            %{
              "env" => [
                %{"name" => "POD_NAME", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.name"}}},
                %{"name" => "SYSTEM_NAMESPACE", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.namespace"}}},
                %{"name" => "CONFIG_LOGGING_NAME", "value" => "config-logging"},
                %{"name" => "CONFIG_OBSERVABILITY_NAME", "value" => "config-observability"},
                %{"name" => "METRICS_DOMAIN", "value" => "knative.dev/internal/serving"}
              ],
              "image" =>
                "gcr.io/knative-releases/knative.dev/serving/cmd/controller@sha256:ea0f8f2ed5a603c42687ad397a4826bb720ea50ce39eef1b3a03927a920e4bc0",
              "livenessProbe" => %{
                "failureThreshold" => 6,
                "httpGet" => %{"path" => "/health", "port" => "probes", "scheme" => "HTTP"},
                "periodSeconds" => 5
              },
              "name" => "controller",
              "ports" => [
                %{"containerPort" => 9090, "name" => "metrics"},
                %{"containerPort" => 8008, "name" => "profiling"},
                %{"containerPort" => 8080, "name" => "probes"}
              ],
              "readinessProbe" => %{
                "failureThreshold" => 3,
                "httpGet" => %{"path" => "/readiness", "port" => "probes", "scheme" => "HTTP"},
                "periodSeconds" => 5
              },
              "resources" => %{
                "limits" => %{"cpu" => "1000m", "memory" => "1000Mi"},
                "requests" => %{"cpu" => "100m", "memory" => "100Mi"}
              },
              "securityContext" => %{
                "allowPrivilegeEscalation" => false,
                "capabilities" => %{"drop" => ["ALL"]},
                "readOnlyRootFilesystem" => true,
                "runAsNonRoot" => true,
                "seccompProfile" => %{"type" => "RuntimeDefault"}
              }
            }
          ],
          "serviceAccountName" => "controller"
        }
      }
      |> B.app_labels(@app_name)
      |> B.component_label("controller")
      |> B.label("role", "controller")

    spec =
      %{}
      |> Map.put("selector", %{
        "matchLabels" => %{"battery/app" => @app_name, "battery/component" => "controller"}
      })
      |> B.template(template)

    :deployment
    |> B.build_resource()
    |> B.name("controller")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
    |> B.spec(spec)
  end

  resource(:deployment_webhook, battery, _state) do
    template =
      %{
        "metadata" => %{
          "labels" => %{
            "battery/managed" => "true"
          }
        },
        "spec" => %{
          "affinity" => %{
            "podAntiAffinity" => %{
              "preferredDuringSchedulingIgnoredDuringExecution" => [
                %{
                  "podAffinityTerm" => %{
                    "labelSelector" => %{
                      "matchLabels" => %{"battery/app" => @app_name, "battery/component" => "webhook"}
                    },
                    "topologyKey" => "kubernetes.io/hostname"
                  },
                  "weight" => 100
                }
              ]
            }
          },
          "containers" => [
            %{
              "env" => [
                %{"name" => "POD_NAME", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.name"}}},
                %{"name" => "SYSTEM_NAMESPACE", "valueFrom" => %{"fieldRef" => %{"fieldPath" => "metadata.namespace"}}},
                %{"name" => "CONFIG_LOGGING_NAME", "value" => "config-logging"},
                %{"name" => "CONFIG_OBSERVABILITY_NAME", "value" => "config-observability"},
                %{"name" => "WEBHOOK_NAME", "value" => "webhook"},
                %{"name" => "WEBHOOK_PORT", "value" => "8443"},
                %{"name" => "METRICS_DOMAIN", "value" => "knative.dev/internal/serving"}
              ],
              "image" =>
                "gcr.io/knative-releases/knative.dev/serving/cmd/webhook@sha256:8883f4fff5c56ed512cc4a3a3ab178b7a3366e58ea2e6aee83d33bc6d287aa48",
              "livenessProbe" => %{
                "failureThreshold" => 6,
                "httpGet" => %{
                  "httpHeaders" => [%{"name" => "k-kubelet-probe", "value" => "webhook"}],
                  "port" => 8443,
                  "scheme" => "HTTPS"
                },
                "initialDelaySeconds" => 20,
                "periodSeconds" => 1
              },
              "name" => "webhook",
              "ports" => [
                %{"containerPort" => 9090, "name" => "metrics"},
                %{"containerPort" => 8008, "name" => "profiling"},
                %{"containerPort" => 8443, "name" => "https-webhook"}
              ],
              "readinessProbe" => %{
                "httpGet" => %{
                  "httpHeaders" => [%{"name" => "k-kubelet-probe", "value" => "webhook"}],
                  "port" => 8443,
                  "scheme" => "HTTPS"
                },
                "periodSeconds" => 1
              },
              "resources" => %{
                "limits" => %{"cpu" => "500m", "memory" => "500Mi"},
                "requests" => %{"cpu" => "100m", "memory" => "100Mi"}
              },
              "securityContext" => %{
                "allowPrivilegeEscalation" => false,
                "capabilities" => %{"drop" => ["ALL"]},
                "readOnlyRootFilesystem" => true,
                "runAsNonRoot" => true,
                "seccompProfile" => %{"type" => "RuntimeDefault"}
              }
            }
          ],
          "serviceAccountName" => "controller",
          "terminationGracePeriodSeconds" => 300
        }
      }
      |> B.app_labels(@app_name)
      |> B.component_label("webhook")

    spec =
      %{}
      |> Map.put(
        "selector",
        %{"matchLabels" => %{"battery/app" => @app_name, "battery/component" => "webhook"}}
      )
      |> B.template(template)

    :deployment
    |> B.build_resource()
    |> B.name("webhook")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("webhook")
    |> B.spec(spec)
  end

  resource(:horizontal_pod_autoscaler_activator, battery, _state) do
    spec =
      %{}
      |> Map.put("maxReplicas", 20)
      |> Map.put("metrics", [
        %{
          "resource" => %{"name" => "cpu", "target" => %{"averageUtilization" => 100, "type" => "Utilization"}},
          "type" => "Resource"
        }
      ])
      |> Map.put("minReplicas", 1)
      |> Map.put(
        "scaleTargetRef",
        %{"apiVersion" => "apps/v1", "kind" => "Deployment", "name" => "activator"}
      )

    :horizontal_pod_autoscaler
    |> B.build_resource()
    |> B.name("activator")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("activator")
    |> B.spec(spec)
  end

  resource(:horizontal_pod_autoscaler_webhook, battery, _state) do
    spec =
      %{}
      |> Map.put("maxReplicas", 5)
      |> Map.put("metrics", [
        %{
          "resource" => %{
            "name" => "cpu",
            "target" => %{"averageUtilization" => 100, "type" => "Utilization"}
          },
          "type" => "Resource"
        }
      ])
      |> Map.put("minReplicas", 1)
      |> Map.put(
        "scaleTargetRef",
        %{"apiVersion" => "apps/v1", "kind" => "Deployment", "name" => "webhook"}
      )

    :horizontal_pod_autoscaler
    |> B.build_resource()
    |> B.name("webhook")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("webhook")
    |> B.spec(spec)
  end

  resource(:knative_image_queue_proxy, battery, _state) do
    spec =
      Map.put(
        %{},
        "image",
        "gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:739d6ce20e3a4eb646d47472163eca88df59bb637cad4d1e100de07a15fe63a2"
      )

    :knative_image
    |> B.build_resource()
    |> B.name("queue-proxy")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("queue-proxy")
    |> B.spec(spec)
  end

  resource(:mutating_webhook_config_serving_knative_dev, battery, _state) do
    rules = [
      %{
        "apiGroups" => ["autoscaling.internal.knative.dev", "networking.internal.knative.dev", "serving.knative.dev"],
        "apiVersions" => ["*"],
        "operations" => ["CREATE", "UPDATE"],
        "resources" => [
          "metrics",
          "podautoscalers",
          "certificates",
          "ingresses",
          "serverlessservices",
          "configurations",
          "revisions",
          "routes",
          "services",
          "domainmappings",
          "domainmappings/status"
        ],
        "scope" => "*"
      }
    ]

    webhooks = [
      %{
        "admissionReviewVersions" => ["v1", "v1beta1"],
        "clientConfig" => %{"service" => %{"name" => "webhook", "namespace" => battery.config.namespace}},
        "failurePolicy" => "Fail",
        "name" => "webhook.serving.knative.dev",
        "rules" => rules,
        "sideEffects" => "None",
        "timeoutSeconds" => 10
      }
    ]

    :mutating_webhook_config
    |> B.build_resource()
    |> B.name("webhook.serving.knative.dev")
    |> B.component_label("webhook")
    |> Map.put("webhooks", webhooks)
  end

  resource(:namespace_knative_serving, battery, _state) do
    :namespace
    |> B.build_resource()
    |> B.name(battery.config.namespace)
    |> B.label("istio-injection", "enabled")
  end

  resource(:pod_disruption_budget_activator_pdb, battery, _state) do
    spec =
      %{}
      |> Map.put("minAvailable", "80%")
      |> Map.put("selector", %{"matchLabels" => %{"battery/app" => @app_name, "battery/component" => "activator"}})

    :pod_disruption_budget
    |> B.build_resource()
    |> B.name("activator-pdb")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("activator")
    |> B.spec(spec)
  end

  resource(:pod_disruption_budget_webhook_pdb, battery, _state) do
    spec =
      %{}
      |> Map.put("minAvailable", "80%")
      |> Map.put("selector", %{"matchLabels" => %{"battery/app" => @app_name, "battery/component" => "webhook"}})

    :pod_disruption_budget
    |> B.build_resource()
    |> B.name("webhook-pdb")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("webhook")
    |> B.spec(spec)
  end

  resource(:role_binding_activator, battery, _state) do
    :role_binding
    |> B.build_resource()
    |> B.name("knative-serving-activator")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("activator")
    |> B.role_ref(B.build_role_ref("knative-serving-activator"))
    |> B.subject(B.build_service_account("activator", battery.config.namespace))
  end

  resource(:role_activator, battery, _state) do
    rules = [
      %{"apiGroups" => [""], "resources" => ["configmaps", "secrets"], "verbs" => ["get", "list", "watch"]},
      %{
        "apiGroups" => [""],
        "resourceNames" => ["routing-serving-certs", "knative-serving-certs"],
        "resources" => ["secrets"],
        "verbs" => ["get", "list", "watch"]
      }
    ]

    :role
    |> B.build_resource()
    |> B.name("knative-serving-activator")
    |> B.namespace(battery.config.namespace)
    |> B.label("serving.knative.dev/controller", "true")
    |> B.rules(rules)
  end

  resource(:secret_certs, battery, _state) do
    data = Secret.encode(%{})

    :secret
    |> B.build_resource()
    |> B.name("knative-serving-certs")
    |> B.namespace(battery.config.namespace)
    |> B.label("networking.internal.knative.dev/certificate-uid", "serving-certs")
    |> B.label("serving-certs-ctrl", "data-plane")
    |> B.data(data)
  end

  resource(:secret_routing_serving_certs, battery, _state) do
    data = Secret.encode(%{})

    :secret
    |> B.build_resource()
    |> B.name("routing-serving-certs")
    |> B.namespace(battery.config.namespace)
    |> B.label("networking.internal.knative.dev/certificate-uid", "serving-certs")
    |> B.label("serving-certs-ctrl", "data-plane-routing")
    |> B.data(data)
  end

  resource(:secret_serving_certs_ctrl_ca, battery, _state) do
    data = Secret.encode(%{})

    :secret
    |> B.build_resource()
    |> B.name("serving-certs-ctrl-ca")
    |> B.namespace(battery.config.namespace)
    |> B.label("networking.internal.knative.dev/certificate-uid", "serving-certs")
    |> B.label("serving-certs-ctrl", "data-plane")
    |> B.data(data)
  end

  resource(:secret_webhook_certs, battery, _state) do
    data = Secret.encode(%{})

    :secret
    |> B.build_resource()
    |> B.name("webhook-certs")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("webhook")
    |> B.data(data)
  end

  resource(:service_account_activator, battery, _state) do
    :service_account
    |> B.build_resource()
    |> B.name("activator")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("activator")
  end

  resource(:service_account_controller, battery, _state) do
    :service_account
    |> B.build_resource()
    |> B.name("controller")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
  end

  resource(:service_activator, battery, _state) do
    spec =
      %{}
      |> Map.put("ports", [
        %{"name" => "http-metrics", "port" => 9090, "targetPort" => 9090},
        %{"name" => "http-profiling", "port" => 8008, "targetPort" => 8008},
        %{"name" => "http", "port" => 80, "targetPort" => 8012},
        %{"name" => "http2", "port" => 81, "targetPort" => 8013},
        %{"name" => "https", "port" => 443, "targetPort" => 8112}
      ])
      |> Map.put("selector", %{"battery/app" => @app_name, "battery/component" => "activator"})

    :service
    |> B.build_resource()
    |> B.name("activator-service")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("activator")
    |> B.spec(spec)
  end

  resource(:service_autoscaler, battery, _state) do
    spec =
      %{}
      |> Map.put("ports", [
        %{"name" => "http-metrics", "port" => 9090, "targetPort" => 9090},
        %{"name" => "http-profiling", "port" => 8008, "targetPort" => 8008},
        %{"name" => "http", "port" => 8080, "targetPort" => 8080}
      ])
      |> Map.put("selector", %{"battery/app" => @app_name, "battery/component" => "autoscaler"})

    :service
    |> B.build_resource()
    |> B.name("autoscaler")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("autoscaler")
    |> B.spec(spec)
  end

  resource(:service_controller, battery, _state) do
    spec =
      %{}
      |> Map.put("ports", [
        %{"name" => "http-metrics", "port" => 9090, "targetPort" => 9090},
        %{"name" => "http-profiling", "port" => 8008, "targetPort" => 8008}
      ])
      |> Map.put("selector", %{"battery/app" => @app_name, "battery/component" => "controller"})

    :service
    |> B.build_resource()
    |> B.name("controller")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("controller")
    |> B.spec(spec)
  end

  resource(:service_webhook, battery, _state) do
    spec =
      %{}
      |> Map.put("ports", [
        %{"name" => "http-metrics", "port" => 9090, "targetPort" => 9090},
        %{"name" => "http-profiling", "port" => 8008, "targetPort" => 8008},
        %{"name" => "https-webhook", "port" => 443, "targetPort" => 8443}
      ])
      |> Map.put("selector", %{"battery/app" => @app_name, "battery/component" => "webhook"})

    :service
    |> B.build_resource()
    |> B.name("webhook")
    |> B.namespace(battery.config.namespace)
    |> B.component_label("webhook")
    |> B.spec(spec)
  end

  resource(:validating_webhook_config_serving_knative_dev, battery, _state) do
    :validating_webhook_config
    |> B.build_resource()
    |> B.name("config.webhook.serving.knative.dev")
    |> B.component_label("webhook")
    |> Map.put("webhooks", [
      %{
        "admissionReviewVersions" => ["v1", "v1beta1"],
        "clientConfig" => %{"service" => %{"name" => "webhook", "namespace" => battery.config.namespace}},
        "failurePolicy" => "Fail",
        "name" => "config.webhook.serving.knative.dev",
        "objectSelector" => %{
          "matchExpressions" => [
            %{"key" => "app.kubernetes.io/name", "operator" => "In", "values" => [@app_name]},
            %{
              "key" => "app.kubernetes.io/component",
              "operator" => "In",
              "values" => ["autoscaler", "controller", "logging", "networking", "observability", "tracing"]
            }
          ]
        },
        "sideEffects" => "None",
        "timeoutSeconds" => 10
      }
    ])
  end

  resource(:validating_webhook_config_validation_serving_knative_dev, battery, _state) do
    :validating_webhook_config
    |> B.build_resource()
    |> B.name("validation.webhook.serving.knative.dev")
    |> B.component_label("webhook")
    |> Map.put("webhooks", [
      %{
        "admissionReviewVersions" => ["v1", "v1beta1"],
        "clientConfig" => %{"service" => %{"name" => "webhook", "namespace" => battery.config.namespace}},
        "failurePolicy" => "Fail",
        "name" => "validation.webhook.serving.knative.dev",
        "rules" => [
          %{
            "apiGroups" => ["autoscaling.internal.knative.dev", "networking.internal.knative.dev", "serving.knative.dev"],
            "apiVersions" => ["*"],
            "operations" => ["CREATE", "UPDATE", "DELETE"],
            "resources" => [
              "metrics",
              "podautoscalers",
              "certificates",
              "ingresses",
              "serverlessservices",
              "configurations",
              "revisions",
              "routes",
              "services",
              "domainmappings",
              "domainmappings/status"
            ],
            "scope" => "*"
          }
        ],
        "sideEffects" => "None",
        "timeoutSeconds" => 10
      }
    ])
  end
end
