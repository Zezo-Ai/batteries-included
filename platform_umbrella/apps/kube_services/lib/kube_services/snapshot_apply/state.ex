defmodule KubeServices.SnapshotApply.State do
  use GenServer

  alias ControlServer.SnapshotApply, as: ControlSnapshotApply
  alias ControlServer.SnapshotApply.KubeSnapshot

  require Logger

  def start_link([snapshot, notify_targets]) do
    GenServer.start_link(__MODULE__, %{
      kube_snapshot: snapshot,
      notify_targets: notify_targets
    })
  end

  @impl true
  def init(state) do
    state = %{state | kube_snapshot: get_or_create_snapshot(state)}
    {:ok, state}
  end

  def get_kube_snapshot(pid) do
    GenServer.call(pid, :get_snapshot)
  end

  def advance_kube_snapshot(pid), do: GenServer.call(pid, :advance_kube_snapshot)

  def path_success(pid, resource_path, reason),
    do: GenServer.cast(pid, {:path_success, resource_path, reason})

  def path_failure(pid, resource_path, reason),
    do: GenServer.cast(pid, {:path_failure, resource_path, reason})

  def count_outstanding(pid), do: GenServer.call(pid, :count_outstanding)

  def count_failed(pid), do: GenServer.call(pid, :count_failed)

  def success(pid), do: GenServer.cast(pid, :success)

  def failure(pid), do: GenServer.cast(pid, :failure)

  def add_notify(pid, target), do: GenServer.cast(pid, {:add_notify, target})

  @impl true
  def handle_call(:get_snapshot, _from, %{kube_snapshot: kube_snapshot} = state),
    do: {:reply, kube_snapshot, state}

  @impl true
  def handle_call(:count_outstanding, _from, %{kube_snapshot: kube_snapshot} = state),
    do: {:reply, count_resource_paths_outstanding(kube_snapshot), state}

  @impl true
  def handle_call(:count_failed, _from, %{kube_snapshot: kube_snapshot} = state),
    do: {:reply, count_resource_paths_failed(kube_snapshot), state}

  @impl true
  def handle_call(:advance_kube_snapshot, _from, %{kube_snapshot: snapshot} = state) do
    case snapshot.status do
      :applying ->
        # Applying is going to wait for all the resource paths to complete
        {:reply, {:ok, snapshot}, state}

      _ ->
        updated_snap = update_status(snapshot, KubeSnapshot.next_status(snapshot))

        {:reply, {:ok, updated_snap}, %{state | kube_snapshot: updated_snap}}
    end
  end

  @impl true
  def handle_call({:add_notify, target}, _from, %{notify_targets: notify_targets} = state),
    do: {:reply, :ok, %{state | notify_targets: [target | notify_targets]}}

  @impl true
  def handle_cast({:path_success, resource_path, reason}, state) do
    update_path_success(resource_path, reason)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:path_failure, resource_path, reason}, state) do
    update_path_failure(resource_path, reason)
    {:noreply, state}
  end

  @impl true
  def handle_cast(:success, %{kube_snapshot: snapshot, notify_targets: notify_targets} = state) do
    updated_snap = update_status(snapshot, :ok)

    notify_targets(notify_targets, updated_snap)

    {:noreply, %{state | kube_snapshot: updated_snap}}
  end

  @impl true
  def handle_cast(:failure, %{kube_snapshot: snapshot, notify_targets: notify_targets} = state) do
    updated_snap = update_status(snapshot, :error)

    notify_targets(notify_targets, updated_snap)

    {:noreply, %{state | kube_snapshot: updated_snap}}
  end

  defp get_or_create_snapshot(%{kube_snapshot: s}) when not is_nil(s), do: s

  defp get_or_create_snapshot(_) do
    with {:ok, snapshot} <- ControlSnapshotApply.create_kube_snapshot() do
      snapshot
    end
  end

  defp update_path_success(resource_path, reason) do
    with {:ok, new_rp} <-
           ControlSnapshotApply.update_resource_path(resource_path, %{
             is_success: true,
             apply_result: String.slice(inspect(reason), 0, 200)
           }) do
      Logger.debug("Reporting success for path #{resource_path.path}")
      new_rp
    end
  end

  defp update_path_failure(resource_path, reason) do
    Logger.debug("Reporting failure for path #{resource_path.path}")

    with {:ok, new_rp} <-
           ControlSnapshotApply.update_resource_path(resource_path, %{
             is_success: false,
             apply_result: String.slice(inspect(reason), 0, 200)
           }) do
      new_rp
    end
  end

  defp update_status(snapshot, status) do
    with {:ok, new_snap} <-
           ControlSnapshotApply.update_kube_snapshot(snapshot, %{
             status: status
           }) do
      Logger.debug("Advanced #{new_snap.id} new satus = #{new_snap.status}")

      new_snap
    end
  end

  defp count_resource_paths_outstanding(kube_snapshot) do
    kube_snapshot
    |> ControlSnapshotApply.resource_paths_for_snapshot()
    |> ControlSnapshotApply.resource_paths_outstanding()
    |> ControlSnapshotApply.count_paths() || 0
  end

  defp count_resource_paths_failed(kube_snapshot) do
    kube_snapshot
    |> ControlSnapshotApply.resource_paths_for_snapshot()
    |> ControlSnapshotApply.resource_paths_failed()
    |> ControlSnapshotApply.count_paths() || 0
  end

  def notify_targets(nil = _targets, _snapshot), do: nil

  def notify_targets(targets, snapshot) do
    Enum.each(targets, fn target ->
      send(target, {:complete, snapshot})
    end)
  end
end
