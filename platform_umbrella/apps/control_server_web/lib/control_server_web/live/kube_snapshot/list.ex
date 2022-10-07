defmodule ControlServerWeb.Live.KubeSnapshotList do
  use ControlServerWeb, :live_view

  import ControlServerWeb.LeftMenuLayout

  alias ControlServer.SnapshotApply
  alias EventCenter.KubeSnapshot, as: SnapshotEventCenter

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    :ok = SnapshotEventCenter.subscribe()
    {:ok, assign(socket, :snapshots, snapshots([]))}
  end

  def snapshots(params) do
    SnapshotApply.paginated_kube_snapshots(params)
  end

  @impl true
  def handle_info(_unused, socket) do
    {:noreply, assign(socket, :snapshots, snapshots([]))}
  end

  @impl true
  def handle_event("start", _, socket) do
    job = KubeServices.SnapshotApply.CreationWorker.start!()

    Logger.debug("Started oban Job #{job.id}")

    {:noreply, socket}
  end

  defp snapshot_path(snapshot) do
    Routes.kube_snapshot_show_path(ControlServerWeb.Endpoint, :index, snapshot.id)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.layout group={:magic} active={:kube_snapshots}>
      <:title>
        <.title>Kube Deploys</.title>
      </:title>
      <.table id="kube-snapshot-table" rows={@snapshots.entries}>
        <:col :let={snapshot} label="Started">
          <%= Timex.format!(snapshot.inserted_at, "{RFC822z}") %>
        </:col>
        <:col :let={snapshot} label="Status"><%= snapshot.status %></:col>
        <:action :let={snapshot}>
          <.link navigate={snapshot_path(snapshot)} type="styled">Show Snapshot</.link>
        </:action>
      </.table>

      <.h2>Actions</.h2>
      <.body_section>
        <.button phx-click="start">
          Start Deploy
        </.button>
      </.body_section>
    </.layout>
    """
  end
end
