defmodule CommonCore.Resources.VMCluster do
  @moduledoc false
  use CommonCore.Resources.ResourceGenerator, app_name: "victoria-metrics-cluster"

  import CommonCore.StateSummary.Hosts
  import CommonCore.StateSummary.Namespaces

  alias CommonCore.OpenApi.IstioVirtualService.VirtualService
  alias CommonCore.Resources.Builder, as: B
  alias CommonCore.Resources.FilterResource, as: F
  alias CommonCore.Resources.VirtualServiceBuilder, as: V

  @vm_select_port 8481

  resource(:vm_cluster_main, battery, state) do
    namespace = core_namespace(state)

    spec =
      %{}
      |> Map.put("replicationFactor", battery.config.replication_factor)
      |> Map.put("retentionPeriod", "14")
      |> Map.put(
        "vminsert",
        %{
          "extraArgs" => %{},
          "image" => %{"tag" => battery.config.cluster_image_tag},
          "replicaCount" => battery.config.vminsert_replicas,
          "resources" => %{}
        }
      )
      |> Map.put(
        "vmselect",
        %{
          "cacheMountPath" => "/select-cache",
          "image" => %{"tag" => battery.config.cluster_image_tag},
          "replicaCount" => battery.config.vmselect_replicas,
          "resources" => %{},
          "storage" => %{
            "volumeClaimTemplate" => %{
              "spec" => %{
                "resources" => %{
                  "requests" => %{"storage" => battery.config.vmselect_volume_size}
                }
              }
            }
          }
        }
      )
      |> Map.put(
        "vmstorage",
        %{
          "image" => %{"tag" => battery.config.cluster_image_tag},
          "replicaCount" => battery.config.vmstorage_replicas,
          "resources" => %{},
          "storage" => %{
            "volumeClaimTemplate" => %{
              "spec" => %{
                "resources" => %{
                  "requests" => %{"storage" => battery.config.vmstorage_volume_size}
                }
              }
            }
          },
          "storageDataPath" => "/vm-data"
        }
      )

    :vm_cluster
    |> B.build_resource()
    |> B.name("main-cluster")
    |> B.namespace(namespace)
    |> B.spec(spec)
  end

  resource(:virtual_service_main, _battery, state) do
    namespace = core_namespace(state)

    spec =
      [hosts: [vmselect_host(state)]]
      |> VirtualService.new!()
      |> V.fallback("vmselect-main-cluster", @vm_select_port)

    :istio_virtual_service
    |> B.build_resource()
    |> B.name("vmselect")
    |> B.namespace(namespace)
    |> B.spec(spec)
    |> F.require_battery(state, :istio_gateway)
  end

  resource(:config_map_grafana_datasource, _battery, state) do
    namespace = core_namespace(state)

    datasources = %{
      "apiVersion" => 1,
      "datasources" => [
        %{
          "name" => "vmselect",
          "type" => "prometheus",
          "orgId" => 1,
          "isDefault" => true,
          "url" => "http://vmselect-main-cluster.#{namespace}.svc.cluster.local:#{@vm_select_port}/select/0/prometheus/"
        }
      ]
    }

    data = %{"vmselect-datasources.yaml" => Ymlr.document!(datasources)}

    :config_map
    |> B.build_resource()
    |> B.name("grafana-datasource-vmselect")
    |> B.namespace(namespace)
    |> B.data(data)
    |> B.label("grafana_datasource", "1")
    |> F.require_battery(state, :grafana)
  end
end
