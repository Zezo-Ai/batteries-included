defmodule ControlServerWeb.Live.PostgresShow do
  use ControlServerWeb, :live_view

  import CommonUI.Stats
  import ControlServerWeb.LeftMenuLayout
  import ControlServerWeb.PodsDisplay
  import ControlServerWeb.ServicesDisplay

  alias ControlServer.Postgres
  alias KubeExt.KubeState
  alias KubeExt.OwnerLabel
  alias EventCenter.KubeState, as: KubeEventCenter

  @impl true
  def mount(_params, _session, socket) do
    :ok = KubeEventCenter.subscribe(:pod)
    :ok = KubeEventCenter.subscribe(:postgresql)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:id, id)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:cluster, Postgres.get_cluster!(id))
     |> assign(:k8_cluster, k8_cluster(id))
     |> assign(:k8_services, k8_services(id))
     |> assign(:k8_pods, k8_pods(id))}
  end

  @impl true
  def handle_info(_unused, socket) do
    {:noreply,
     socket
     |> assign(:k8_cluster, k8_cluster(socket.assigns.id))
     |> assign(:k8_services, k8_services(socket.assigns.id))
     |> assign(:k8_pods, k8_pods(socket.assigns.id))}
  end

  @impl true
  def handle_event("delete", _, socket) do
    {:ok, _} = Postgres.delete_cluster(socket.assigns.cluster)

    {:noreply, push_redirect(socket, to: Routes.postgres_clusters_path(socket, :index))}
  end

  defp page_title(:show), do: "Show Postgres"

  defp edit_url(cluster),
    do: Routes.postgres_edit_path(ControlServerWeb.Endpoint, :edit, cluster.id)

  defp k8_cluster(id) do
    Enum.find(KubeState.postgresqls(), nil, fn pg -> id == OwnerLabel.get_owner(pg) end)
  end

  defp k8_pods(id) do
    Enum.filter(KubeState.pods(), fn pg -> id == OwnerLabel.get_owner(pg) end)
  end

  defp k8_services(id) do
    Enum.filter(KubeState.services(), fn pg -> id == OwnerLabel.get_owner(pg) end)
  end

  defp k8_cluster_status(nil) do
    "Not Running"
  end

  defp k8_cluster_status(k8_cluster) do
    k8_cluster |> Map.get("status", %{}) |> Map.get("PostgresClusterStatus", "Not Running")
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.layout>
      <:title>
        <.title><%= @page_title %></.title>
      </:title>
      <:left_menu>
        <.data_menu active="postgres" />
      </:left_menu>
      <.h3>Cluster Summary</.h3>
      <.stats>
        <.stat>
          <.stat_title>Name</.stat_title>
          <.stat_value><%= @cluster.name %></.stat_value>
        </.stat>
        <.stat>
          <.stat_title>Instances</.stat_title>
          <.stat_description>The number of replics to run</.stat_description>
          <.stat_value><%= @cluster.num_instances %></.stat_value>
        </.stat>
        <.stat>
          <.stat_title>PG Version</.stat_title>
          <.stat_description>Major Version of Postgres</.stat_description>
          <.stat_value><%= @cluster.postgres_version %></.stat_value>
        </.stat>
        <.stat>
          <.stat_title>Cluster Status</.stat_title>
          <.stat_value><%= k8_cluster_status(@k8_cluster) %></.stat_value>
        </.stat>
      </.stats>

      <.h3>Pods</.h3>
      <.body_section>
        <.pods_display pods={@k8_pods} />
      </.body_section>

      <.h3>Services</.h3>
      <.body_section>
        <.services_display services={@k8_services} />
      </.body_section>

      <.h3>Actions</.h3>
      <.body_section>
        <.link to={edit_url(@cluster)}>
          <.button>
            Edit Cluster
          </.button>
        </.link>

        <.button phx_click="delete" color={:warning} data={[confirm: "Are you sure?"]}>
          Delete Cluster
        </.button>
      </.body_section>
    </.layout>
    """
  end
end
