defmodule ControlServerWeb.Live.PostgresClusters do
  @moduledoc """
  Live web app for database stored json configs.
  """
  use ControlServerWeb, :live_view

  import ControlServerWeb.LeftMenuLayout
  import ControlServerWeb.PostgresClusterDisplay

  alias ControlServer.Postgres

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :clusters, list_clusters())}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp list_clusters do
    Postgres.list_clusters()
  end

  defp new_url, do: ~p"/postgres/clusters/new"

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.layout group={:data} active={:postgres_operator}>
      <:title>
        <.title>Postgres Clusters</.title>
      </:title>

      <.pg_cluster_display clusters={@clusters} />
      <.h2>Actions</.h2>
      <.body_section>
        <.link navigate={new_url()}>
          <.button>
            New Cluster
          </.button>
        </.link>
      </.body_section>
    </.layout>
    """
  end
end
