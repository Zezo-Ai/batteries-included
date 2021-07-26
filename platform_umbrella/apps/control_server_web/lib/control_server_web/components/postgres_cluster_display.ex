defmodule ControlServerWeb.PostgresClusterDisplay do
  use Surface.Component

  alias CommonUI.Button
  alias CommonUI.ShadowContainer
  alias ControlServerWeb.Router.Helpers, as: Routes
  alias Surface.Components.LivePatch

  prop clusters, :list, default: []

  @impl true
  def render(assigns) do
    ~F"""
    <h3 class="my-2 text-lg leading-7 sm:text-3xl sm:truncate">
      Postgres Clusters
    </h3>

    <ShadowContainer>
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-100">
          <tr>
            <th
              scope="col"
              class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase"
            >
              Name
            </th>
            <th
              scope="col"
              class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase"
            >
              Version
            </th>
            <th
              scope="col"
              class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase"
            >
              Replicas
            </th>
            <th
              scope="col"
              class="px-6 py-3 text-xs font-medium tracking-wider text-left text-gray-500 uppercase"
            >
              Actions
            </th>
          </tr>
        </thead>
        <tbody>
          {#for {cluster, idx} <- Enum.with_index(@clusters)}
            {cluster_row(cluster, idx, assigns)}
          {/for}
        </tbody>
      </table>
    </ShadowContainer>

    <LivePatch to="/services/database/clusters/new" class="ml-8 mt-15">
      <Button type="primary">
        New Cluster
      </Button>
    </LivePatch>
    """
  end

  defp cluster_row(cluster, idx, assigns) do
    ~F"""
    <tr class={"bg-white": rem(idx, 2) == 0, "bg-gray-100": rem(idx, 2) == 1}>
      <td scope="row" class="px-6 py-4 text-sm font-medium text-gray-900 whitespace-nowrap">
        {cluster.name}
      </td>
      <td class="px-6 py-4 text-sm text-gray-500 whitespace-nowrap">
        {cluster.postgres_version}
      </td>
      <td class="px-6 py-4 text-sm text-gray-500 whitespace-nowrap">
        {cluster.num_instances}
      </td>

      <td class="px-6 py-4 text-sm text-gray-500 whitespace-nowrap">
        <span>
          <LivePatch to="/" class="mt-8 text-lg font-medium text-left">
            Edit Cluster
          </LivePatch>
        </span>
      </td>
    </tr>
    """
  end
end
