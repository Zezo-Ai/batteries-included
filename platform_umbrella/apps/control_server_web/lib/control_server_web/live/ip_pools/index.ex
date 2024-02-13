defmodule ControlServerWeb.Live.IPAddressPoolIndex do
  @moduledoc """
  Live web app for database stored json configs.
  """
  use ControlServerWeb, {:live_view, layout: :sidebar}

  import ControlServerWeb.IPAddressPoolsTable

  alias ControlServer.MetalLB

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "MetalLB")
     |> assign(:ip_address_pools, MetalLB.list_ip_address_pools())
     |> assign(:current_page, :net_sec)}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} = id |> MetalLB.get_ip_address_pool!() |> MetalLB.delete_ip_address_pool()
    {:noreply, push_redirect(socket, to: ~p"/ip_address_pools")}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.page_header title={@page_title} back_button={%{link_type: "live_redirect", to: "/net_sec"}} />

    <.panel title="IP Addresses">
      <:menu>
        <.a variant="icon" icon={:plus} navigate={new_url()}>
          New IP Address Pool
        </.a>
      </:menu>

      <.ip_address_pools_table abbridged rows={@ip_address_pools} />
    </.panel>
    """
  end

  defp new_url, do: ~p"/ip_address_pools/new"
end
