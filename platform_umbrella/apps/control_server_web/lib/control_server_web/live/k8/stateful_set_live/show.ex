defmodule ControlServerWeb.StatefulSetLive.Show do
  @moduledoc false
  use ControlServerWeb, {:live_view, layout: :sidebar}

  import CommonCore.Resources.FieldAccessors
  import ControlServerWeb.PodsTable
  import ControlServerWeb.ResourceComponents

  alias EventCenter.KubeState, as: KubeEventCenter
  alias KubeServices.KubeState

  require Logger

  @resource_type :stateful_set

  @impl Phoenix.LiveView
  def mount(%{"name" => name, "namespace" => namespace}, _session, socket) do
    :ok = KubeEventCenter.subscribe(@resource_type)
    resource = get_resource!(namespace, name)

    {:ok,
     socket
     |> assign(
       current_page: :kubernetes,
       resource: resource,
       namespace: namespace,
       name: name
     )
     |> assign_subresources(resource)}
  end

  defp assign_subresources(socket, resource) do
    assign(socket,
      pods: KubeState.get_owned_resources(:pod, resource),
      events: KubeState.get_events(resource),
      conditions: conditions(resource),
      status: status(resource)
    )
  end

  @impl Phoenix.LiveView
  def handle_info(_unused, socket) do
    # re-fetch the resources
    resource = get_resource!(socket.assigns.namespace, socket.assigns.name)

    {:noreply,
     socket
     |> assign(resource: resource)
     |> assign_subresources(resource)}
  end

  defp get_resource!(namespace, name) do
    KubeState.get!(@resource_type, namespace, name)
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.page_header
      title={@name}
      back_button={%{link_type: "live_redirect", to: ~p"/kube/stateful_sets"}}
    />

    <div class="flex flex-col gap-8 mb-10">
      <.data_pills class="mt-8">
        <:item title="Total Replicas"><%= Map.get(@status, "replicas", 0) %></:item>
        <:item title="Available Replicas"><%= Map.get(@status, "availableReplicas", 0) %></:item>
        <:item title="Unavailable Replicas"><%= Map.get(@status, "unavailableReplicas", 0) %></:item>
        <:item title="Updated Replicas"><%= Map.get(@status, "updatedReplicas", 0) %></:item>
        <:item title="Generations"><%= Map.get(@status, "Generations", 0) %></:item>
      </.data_pills>
      <.panel title="Pods">
        <.pods_table pods={@pods} />
      </.panel>
      <.events_section events={@events} />
      <.label_section resource={@resource} />
    </div>
    """
  end
end
