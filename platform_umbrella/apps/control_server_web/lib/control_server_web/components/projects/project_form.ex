defmodule ControlServerWeb.Projects.ProjectForm do
  @moduledoc false
  use ControlServerWeb, :live_component

  alias CommonCore.Projects.Project
  alias ControlServer.Projects

  def mount(socket) do
    changeset = Projects.change_project(%Project{})

    {:ok,
     socket
     |> assign(:class, nil)
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      %Project{}
      |> Projects.change_project(project_params)
      |> Map.put(:action, :validate)

    # Send project type changes to the parent live view so the steps can be updated
    if project_type = Ecto.Changeset.get_change(changeset, :type) do
      send(self(), {:project_type, project_type})
    end

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    project = Projects.change_project(%Project{}, project_params)

    case Ecto.Changeset.apply_action(project, :insert) do
      {:ok, _} ->
        # Don't create the project yet, just send the data to the parent component
        send(self(), {:next, {__MODULE__, project_params}})

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="contents">
      <.simple_form
        id={@id}
        for={@form}
        class={@class}
        variant="stepped"
        title="Tell More About Your Project"
        description="A place for introductory information about this stage of project creation"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} label="Project Name" placeholder="Enter project name" />

        <.input
          field={@form[:type]}
          type="select"
          label="Project Type"
          placeholder="Select project type"
          options={Project.type_options_for_select()}
        />

        <div class="xl:col-span-2">
          <.input
            field={@form[:description]}
            type="textarea"
            label="Project Description"
            placeholder="Enter a project description (optional)"
            maxlength={1000}
          />
        </div>

        <:actions>
          <%= render_slot(@inner_block) %>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
