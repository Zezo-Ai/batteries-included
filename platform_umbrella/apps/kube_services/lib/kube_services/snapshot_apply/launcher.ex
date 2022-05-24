defmodule KubeServices.SnapshotApply.Launcher do
  use GenServer

  alias EventCenter.KubeSnapshot, as: SnapshotEventCenter

  require Logger

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, %{running: nil, started: nil}, name: name)
  end

  def init(state) do
    :ok = SnapshotEventCenter.subscribe()
    {:ok, state}
  end

  def launch(opts \\ []), do: launch(__MODULE__, opts)

  def launch(launcher_target, opts) do
    snapshot = Keyword.get(opts, :snapshot, nil)
    GenServer.call(launcher_target, {:launch, snapshot})
  end

  def handle_call({:launch, snapshot}, _from, %{running: running} = state) do
    if running == nil do
      {pid, new_state} = do_launch(snapshot, state)
      {:reply, pid, new_state}
    else
      Logger.debug("Not launching still running #{inspect(running)}")
      {:reply, nil, state}
    end
  end

  def handle_info({:DOWN, pid, _, _object, reason}, state) do
    Logger.info("State agent down #{inspect(pid)} down with reason #{reason}")
    {:noreply, %{state | running: nil}}
  end

  def handle_info(%SnapshotEventCenter.Payload{snapshot: _snapshot}, state) do
    {:noreply, %{state | running: nil}}
  end

  defp do_launch(snapshot, state) do
    with {:ok, pid} <- KubeServices.SnapshotApply.Supervisor.start(snapshot) do
      Process.monitor(pid)
      {pid, %{state | running: pid, started: DateTime.utc_now()}}
    end
  end
end
