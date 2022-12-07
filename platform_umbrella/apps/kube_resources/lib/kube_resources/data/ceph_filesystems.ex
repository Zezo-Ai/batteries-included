defmodule KubeResources.CephFilesystems do
  use KubeExt.ResourceGenerator

  import KubeExt.SystemState.Namespaces

  alias KubeExt.Builder, as: B

  multi_resource(:filesystems, battery, state) do
    namespace = data_namespace(state)

    Enum.map(state.ceph_filesystems, fn filesystem ->
      B.build_resource(:ceph_filesystem)
      |> B.name(filesystem.name)
      |> B.namespace(namespace)
      |> B.owner_label(filesystem.id)
      |> B.spec(filesystem_spec(filesystem, battery, state))
    end)
  end

  defp filesystem_spec(%{} = cluster, _battery, _state) do
    %{
      metadataPool: %{replicated: %{size: 3}},
      dataPools: filesystem_datapools(cluster.include_erasure_encoded)
    }
  end

  defp filesystem_datapools(true) do
    filesystem_datapools(false) ++
      [%{name: "erasurecoded", erasureCoded: %{dataChunks: 2, codingChunks: 1}}]
  end

  defp filesystem_datapools(_) do
    [%{name: "replicated", size: 3}]
  end
end
