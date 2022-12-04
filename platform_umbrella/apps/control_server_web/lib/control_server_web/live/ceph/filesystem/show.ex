defmodule ControlServerWeb.Live.CephFilesystemShow do
  use ControlServerWeb, :live_view

  import ControlServerWeb.LeftMenuLayout

  alias ControlServer.Rook

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ceph_filesystem, Rook.get_ceph_filesystem!(id))}
  end

  defp page_title(:show), do: "Show Ceph Filesystem"

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.layout group={:data} active={:rook}>
      <:title>
        <.title><%= @page_title %></.title>
      </:title>

      <.body_section>
        <ul>
          <li>
            <strong>Name:</strong>
            <%= @ceph_filesystem.name %>
          </li>

          <li>
            <strong>Include Erasure Encoding:</strong>
            <%= @ceph_filesystem.include_erasure_encoded %>
          </li>
        </ul>
      </.body_section>

      <span>
        <.link navigate={~p"/ceph/filesystems/#{@ceph_filesystem}/edit"}>Edit</.link>
      </span>
      |
      <span>
        <.link navigate={~p"/ceph"}>Back</.link>
      </span>
    </.layout>
    """
  end
end
