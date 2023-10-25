defmodule CommonCore.Resources.RootResourceGenerator do
  @moduledoc """
  Given any SystemBattery this will extract the kubernetes configs for application to the cluster.
  """
  alias CommonCore.Resources.BatteryCA
  alias CommonCore.Resources.BatteryCore
  alias CommonCore.Resources.CephClusters
  alias CommonCore.Resources.CephFilesystems
  alias CommonCore.Resources.CertManager
  alias CommonCore.Resources.CloudnativePG
  alias CommonCore.Resources.CloudnativePGClusters
  alias CommonCore.Resources.CloudnativePGDashboards
  alias CommonCore.Resources.ControlServer, as: ControlServerResources
  alias CommonCore.Resources.Gitea
  alias CommonCore.Resources.Grafana
  alias CommonCore.Resources.IstioBase
  alias CommonCore.Resources.IstioCsr
  alias CommonCore.Resources.Istiod
  alias CommonCore.Resources.IstioIngress
  alias CommonCore.Resources.IstioMetrics
  alias CommonCore.Resources.Keycloak
  alias CommonCore.Resources.Kiali
  alias CommonCore.Resources.KnativeOperator
  alias CommonCore.Resources.KnativeServing
  alias CommonCore.Resources.KubeDashboards
  alias CommonCore.Resources.KubeMonitoring
  alias CommonCore.Resources.KubeStateMetrics
  alias CommonCore.Resources.Loki
  alias CommonCore.Resources.MetalLB
  alias CommonCore.Resources.MetalLBPools
  alias CommonCore.Resources.NodeExporter
  alias CommonCore.Resources.Notebooks
  alias CommonCore.Resources.Promtail
  alias CommonCore.Resources.Redis
  alias CommonCore.Resources.RedisOperator
  alias CommonCore.Resources.Rook
  alias CommonCore.Resources.Smtp4Dev
  alias CommonCore.Resources.SSO
  alias CommonCore.Resources.TrivyOperator
  alias CommonCore.Resources.TrustManager
  alias CommonCore.Resources.VMAgent
  alias CommonCore.Resources.VMCluster
  alias CommonCore.Resources.VMDashboards
  alias CommonCore.Resources.VMOperator
  alias CommonCore.StateSummary

  require Logger

  @default_generator_mappings [
    battery_ca: [BatteryCA],
    battery_core: [BatteryCore, ControlServerResources],
    cert_manager: [CertManager],
    cloudnative_pg: [CloudnativePG, CloudnativePGClusters, CloudnativePGDashboards],
    gitea: [Gitea],
    grafana: [Grafana],
    istio: [IstioBase, Istiod, IstioMetrics],
    istio_csr: [IstioCsr],
    istio_gateway: [IstioIngress],
    kiali: [Kiali],
    knative_operator: [KnativeOperator],
    knative_serving: [KnativeServing],
    kube_monitoring: [KubeStateMetrics, NodeExporter, KubeMonitoring, KubeDashboards],
    loki: [Loki],
    metallb: [MetalLB, MetalLBPools],
    notebooks: [Notebooks],
    promtail: [Promtail],
    redis: [Redis, RedisOperator],
    rook: [Rook, CephFilesystems, CephClusters],
    smtp4dev: [Smtp4Dev],
    keycloak: [Keycloak],
    sso: [SSO],
    trivy_operator: [TrivyOperator],
    timeline: [],
    trust_manager: [TrustManager],
    vm_operator: [VMOperator],
    vm_agent: [VMAgent],
    vm_cluster: [VMCluster],
    victoria_metrics: [VMDashboards]
  ]

  @spec materialize(StateSummary.t()) :: map()
  def materialize(%StateSummary{batteries: batteries} = state) do
    batteries
    |> Enum.map(fn %{type: type} = sb ->
      # Materialize the battery with the generators
      # We do all generators in one step rather than
      # flat map to allow for conflict resolution of paths.
      materialize_system_battery(
        sb,
        state,
        Keyword.fetch!(@default_generator_mappings, type)
      )
    end)
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  def default_generators, do: @default_generator_mappings

  def materialize_system_battery(system_battery, state, generators) do
    generators
    |> Enum.map(fn mod ->
      mod.materialize(system_battery, state)
    end)
    |> Enum.reduce(%{}, &Map.merge/2)
    |> Enum.flat_map(&flatten/1)
    |> Enum.map(fn {key, resource} ->
      {
        Path.join(["/", Atom.to_string(system_battery.type), key]),
        resource
      }
    end)
    |> Map.new()
  end

  defp flatten({key, values} = _input) when is_list(values) do
    values
    |> Enum.with_index()
    |> Enum.reject(fn {_key, resource} -> resource == nil end)
    |> Enum.map(fn {v, idx} ->
      {Path.join(key, Integer.to_string(idx)), v}
    end)
  end

  defp flatten({key, value}), do: [{key, value}]
end
