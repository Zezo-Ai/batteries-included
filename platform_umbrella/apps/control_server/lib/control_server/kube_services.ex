defmodule ControlServer.KubeServices do
  @moduledoc """
  Module to interact with BaseService and Kubernetes resources.
  """
  use GenServer

  alias ControlServer.ConfigGenerator
  alias ControlServer.KubeExt
  alias ControlServer.Services

  require Logger

  def start_link(_default) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:apply, state) do
    apply_all()
    {:noreply, state}
  end

  @impl true
  def handle_call(:apply_now, _from, state) do
    {:reply, apply_all(), state}
  end

  def apply_all do
    Logger.info("Applying")

    resources =
      Services.list_base_services()
      |> Enum.flat_map(fn service -> ConfigGenerator.materialize(service) end)
      |> Enum.sort(fn {a, _av}, {b, _bv} -> a <= b end)
      |> Enum.map(fn {path, r} ->
        Logger.debug("Applying new config to #{path}")

        with {:ok, _} <- KubeExt.apply(r) do
          r
        end
      end)

    Logger.debug("Completed apply_all with #{length(resources)} resources")
  end

  def start_apply do
    GenServer.cast(__MODULE__, :apply)
  end

  def apply do
    GenServer.call(__MODULE__, :apply_now, 10_000)
  end
end
