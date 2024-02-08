defmodule CommonCore.Resources.CephClusters do
  @moduledoc false
  use CommonCore.Resources.ResourceGenerator, app_name: "ceph-clusters"

  import CommonCore.StateSummary.Namespaces

  alias CommonCore.Resources.Builder, as: B

  multi_resource(:clusters, battery, state) do
    namespace = data_namespace(state)

    Enum.map(state.ceph_clusters, fn cluster ->
      :ceph_cluster
      |> B.build_resource()
      |> B.name(cluster.name)
      |> B.namespace(namespace)
      |> B.app_labels(cluster.name)
      |> B.component_labels(@app_name)
      |> B.add_owner(cluster)
      |> B.spec(cluster_spec(cluster, battery, state))
    end)
  end

  defp cluster_spec(%{} = cluster, battery, _state) do
    %{
      # storage: %{useAllNodes: false, useAllDevices: false, nodes: cluster.nodes},
      network: %{connections: %{encryption: %{enabled: false}, compression: %{enabled: false}}},
      dataDirHostPath: cluster.data_dir_host_path,
      mon: %{count: cluster.num_mon},
      mgr: %{count: cluster.num_mgr},
      cephVersion: %{image: battery.image}
    }
  end
end
