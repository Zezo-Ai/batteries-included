defmodule KubeResources.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cachex, name: :grafana_dashboard_cache},
      KubeResources.GrafanaDashboardClient.child_spec()
    ]

    opts = [strategy: :one_for_one, name: KubeResources.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
