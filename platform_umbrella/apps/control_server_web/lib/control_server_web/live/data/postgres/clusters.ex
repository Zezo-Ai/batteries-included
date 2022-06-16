defmodule ControlServerWeb.Live.PostgresClusters do
  @moduledoc """
  Live web app for database stored json configs.
  """
  use ControlServerWeb, :live_view

  import ControlServerWeb.LeftMenuLayout
  import ControlServerWeb.PostgresClusterDisplay

  alias ControlServer.Postgres

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :clusters, list_clusters())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp list_clusters do
    Postgres.list_clusters()
  end

  defp new_url, do: Routes.postgres_new_path(ControlServerWeb.Endpoint, :new)

  @impl true
  def render(assigns) do
    ~H"""
    <.layout>
      <:title>
        <.title>Postgres Clusters</.title>
      </:title>
      <:left_menu>
        <.data_menu active="postgres" />
      </:left_menu>
      <.h3>Postgres Clusters</.h3>
      <.body_section>
        <.pg_cluster_display clusters={@clusters} />
      </.body_section>

      <.h3>Actions</.h3>
      <.body_section>
        <.link to={new_url()}>
          <.button>
            New Cluster
          </.button>
        </.link>
      </.body_section>
    </.layout>
    """
  end
end
