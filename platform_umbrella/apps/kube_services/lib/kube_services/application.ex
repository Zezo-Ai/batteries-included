defmodule KubeServices.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias KubeExt.ConnectionPool
  alias KubeExt.KubeState
  alias KubeExt.KubeState.ResourceWatcher

  @impl true
  def start(_type, _args) do
    children = children(start_services?())

    opts = [strategy: :one_for_one, name: KubeServices.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_services?, do: Application.get_env(:kube_services, :start_services)

  def children(true = _run) do
    [
      KubeServices.Usage.RestClientGenserver,
      {Oban, Application.fetch_env!(:kube_services, Oban)},
      KubeServices.SnapshotApply.EventLauncher
    ] ++ kube_state_watchers() ++ timeline_watchers()
  end

  def children(_run), do: []

  def kube_state_watchers,
    do:
      specs_for_types(
        KubeExt.ApiVersionKind.all_known(),
        "KubeState.Resource",
        &resource_worker_child_spec/1
      )

  def timeline_watchers do
    specs_for_types(
      [
        :namspace,
        :pod,
        :node,
        :deployment,
        :stateful_set
      ],
      "Timeline.Kube",
      &kube_watcher_child_spec/1
    ) ++
      specs_for_types(
        [
          :jupyter_notebook,
          :knative_service,
          :postgres_cluster,
          :redis_cluster
        ],
        "Timeline.Database",
        &database_watcher_child_spec/1
      )
  end

  defp specs_for_types(types, base_name, func) do
    types
    |> Enum.map(fn type ->
      {type, "#{base_name}.#{Macro.camelize(Atom.to_string(type))}"}
    end)
    |> Enum.map(func)
  end

  defp resource_worker_child_spec({resource_type, id}) do
    Supervisor.child_spec(
      {Bella.Watcher.Worker,
       [
         watcher: ResourceWatcher,
         connection_func: &ConnectionPool.get/0,
         should_retry_watch: true,
         extra: %{
           resource_type: resource_type,
           table_name: KubeState.default_state_table()
         }
       ]},
      id: id
    )
  end

  defp kube_watcher_child_spec({resource_type, id}) do
    Supervisor.child_spec(
      {KubeServices.Timeline.KubeWatcher, [resource_type: resource_type]},
      id: id
    )
  end

  defp database_watcher_child_spec({database_source_type, id}) do
    Supervisor.child_spec(
      {KubeServices.Timeline.DatabaseWatcher, [source_type: database_source_type]},
      id: id
    )
  end
end
