defmodule ControlServerWeb.Projects.ShowLive do
  @moduledoc false
  use ControlServerWeb, {:live_view, layout: :sidebar}

  alias CommonCore.Projects.Project
  alias ControlServer.Projects

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Project Details")
     |> assign(:project, Projects.get_project!(id))}
  end

  def handle_event("delete", _params, socket) do
    {:ok, _} = Projects.delete_project(socket.assigns.project)
    {:noreply, push_navigate(socket, to: ~p"/projects")}
  end

  def render(assigns) do
    ~H"""
    <.page_header title={@project.name} back_link={~p"/projects"}>
      <:menu>
        <.button variant="minimal" icon={:star} />

        <.badge>
          <:item label="Type"><%= Project.type_name(@project.type) %></:item>
        </.badge>
      </:menu>

      <.flex class="items-center">
        <.button variant="icon" icon={:trash} phx-click="delete" data-confirm="Are you sure?" />

        <.button variant="dark" icon={:clock} link={~p"/projects/#{@project.id}/timeline"}>
          Project Timeline
        </.button>
      </.flex>
    </.page_header>

    <.grid columns={%{sm: 1, lg: 2}}>
      <.panel :if={@project.description} title="Project Description">
        <%= @project.description %>
      </.panel>

      <.panel title="Grafana" class={if !@project.description, do: "col-span-2"}>
        <:menu>
          <.button variant="minimal" icon={:arrow_top_right_on_square}>Open in New Tab</.button>
        </:menu>

        <span>Dashboards and Observability charts</span>
      </.panel>

      <.panel variant="gray" title="Batteries Running"></.panel>

      <.panel variant="gray" title="Redis"></.panel>

      <.panel title="Knative Services" class="col-span-2"></.panel>

      <.panel title="Pods" class="col-span-2"></.panel>
    </.grid>
    """
  end
end
