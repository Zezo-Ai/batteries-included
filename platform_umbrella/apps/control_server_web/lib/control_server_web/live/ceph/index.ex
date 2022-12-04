defmodule ControlServerWeb.Live.CephIndex do
  use ControlServerWeb, :live_view

  import ControlServerWeb.LeftMenuLayout

  alias ControlServer.Rook

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:ceph_clusters, list_ceph_clusters())
     |> assign(:ceph_filesystems, list_ceph_filesystems())}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Ceph Status")
    |> assign(:ceph_cluster, nil)
  end

  defp list_ceph_clusters do
    Rook.list_ceph_cluster()
  end

  defp list_ceph_filesystems do
    Rook.list_ceph_filesystem()
  end

  defp clusters_section(assigns) do
    ~H"""
    <.table rows={@ceph_clusters} id="clusters-table">
      <:col :let={ceph} label="Name"><%= ceph.name %></:col>
      <:col :let={ceph} label="Monitors"><%= ceph.num_mon %></:col>
      <:col :let={ceph} label="Managers"><%= ceph.num_mgr %></:col>
      <:col :let={ceph} label="Data dir"><%= ceph.data_dir_host_path %></:col>
      <:action :let={ceph}>
        <.link navigate={~p"/ceph/clusters/#{ceph}/show"} variant="styled">
          Show Cluster
        </.link>
      </:action>
    </.table>
    """
  end

  defp filesystems_section(assigns) do
    ~H"""
    <.table rows={@ceph_filesystems} id="filesystems-table">
      <:col :let={ceph} label="Name"><%= ceph.name %></:col>
      <:col :let={ceph} label="Include EC?"><%= ceph.include_erasure_encoded %></:col>
      <:action :let={ceph}>
        <.link navigate={~p"/ceph/filesystems/#{ceph}/show"} variant="styled">
          Show FileSystem
        </.link>
      </:action>
    </.table>
    """
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.layout group={:data} active={:rook}>
      <:title>
        <.title><%= @page_title %></.title>
      </:title>
      <.section_title>Ceph Clusters</.section_title>

      <.clusters_section ceph_clusters={@ceph_clusters} />

      <.section_title>Ceph FileSystem</.section_title>
      <.filesystems_section ceph_filesystems={@ceph_filesystems} />

      <.h2>Actions</.h2>
      <.body_section>
        <.link navigate={~p"/ceph/clusters/new"}>
          <.button>
            New Cluster
          </.button>
        </.link>

        <.link navigate={~p"/ceph/filesystems/new"}>
          <.button>
            New FileSystem
          </.button>
        </.link>
      </.body_section>
    </.layout>
    """
  end
end
