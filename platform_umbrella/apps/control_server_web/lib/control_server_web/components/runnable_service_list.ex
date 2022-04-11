defmodule ControlServerWeb.RunnableServiceList do
  use ControlServerWeb, :live_component

  import CommonUI.Table

  alias ControlServer.Services.RunnableService

  @impl true

  def mount(socket) do
    {:ok, assign_new(socket, :services, fn -> [] end)}
  end

  @impl true

  def update(assigns, socket) do
    {:ok, assign(socket, :services, update_services(assigns.services))}
  end

  defp update_services(services) when is_list(services) do
    ##
    # From a list of services we recheck if they are running and recreate the map of s.tring service
    services
    |> Enum.map(&update_single_service/1)
    |> Enum.into(%{})
  end

  defp update_services(%{} = services) do
    services
    |> Enum.map(fn {_path, service} -> update_single_service(service) end)
    |> Enum.into(%{})
  end

  def update_single_service(%{service: mod} = _s) do
    update_single_service(mod)
  end

  def update_single_service(service) do
    {"#{service.path}", %{service: service, active: RunnableService.active?(service)}}
  end

  @impl true

  def handle_event("start", %{"path" => path} = _payload, socket) do
    socket.assigns.services
    |> Map.get(path)
    |> Map.get(:service)
    |> RunnableService.activate!()

    {:noreply, assign(socket, :services, update_services(socket.assigns.services))}
  end

  @impl true

  def render(assigns) do
    ~H"""
    <div>
      <.h4>Runnable Services</.h4>
      <.table>
        <.thead>
          <.tr>
            <.th>
              Service Type
            </.th>
            <.th>
              Start
            </.th>
          </.tr>
        </.thead>
        <.tbody>
          <%= for {service_info, idx} <- @services |> Map.values() |> Enum.with_index() do %>
            <.table_row service_info={service_info} idx={idx} target={@myself} />
          <% end %>
        </.tbody>
      </.table>
    </div>
    """
  end

  def table_row(assigns) do
    ~H"""
    <.tr>
      <.td>
        <%= @service_info.service.service_type %>
      </.td>
      <.td>
        <%= if not @service_info.active do %>
          <.button
            label="Start Service"
            variant="shadow"
            phx-click={:start}
            phx-value-path={@service_info.service.path}
            phx-target={@target}
          />
        <% end %>
      </.td>
    </.tr>
    """
  end
end
