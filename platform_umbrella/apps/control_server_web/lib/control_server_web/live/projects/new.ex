defmodule ControlServerWeb.Projects.NewLive do
  @moduledoc false
  use ControlServerWeb, {:live_view, layout: :sidebar}

  alias ControlServer.Projects
  alias ControlServerWeb.Projects.BatteriesForm
  alias ControlServerWeb.Projects.DatabaseForm
  alias ControlServerWeb.Projects.MachineLearningForm
  alias ControlServerWeb.Projects.ProjectForm
  alias ControlServerWeb.Projects.WebForm

  def mount(params, _session, socket) do
    # Allow the back button to be dynamic and go back steps
    return_to = Map.get(params, "return_to", ~p"/projects")
    back_click = JS.push("back", value: %{return_to: return_to})

    {:ok,
     socket
     |> assign(:form_data, %{})
     |> assign(:back_click, back_click)
     |> assign(:steps, steps())
     |> assign(:current_step, List.first(steps()))
     |> assign(:page_title, "Start Your Project")}
  end

  # Updates the project steps when the type changes in the new project subform.
  # It also resets the form data so we don't create resources from a previously-selected type.
  def handle_info({:project_type, project_type}, socket) do
    {:noreply,
     socket
     |> assign(:form_data, %{})
     |> assign(:steps, steps(project_type))}
  end

  # Moves to the next step when sub-forms are submitted. This will store the sub-form data in the
  # assigns until the end of the new project flow, when all the resources will be created at once.
  def handle_info({:next, {step, step_data}}, socket) do
    form_data = Map.put(socket.assigns.form_data, step, step_data)
    next_index = Enum.find_index(socket.assigns.steps, &(&1 == step)) + 1

    if next_step = Enum.at(socket.assigns.steps, next_index) do
      # There are still more steps in the flow, save form data and move to next step
      {:noreply,
       socket
       |> assign(:form_data, form_data)
       |> assign(:current_step, next_step)}
    else
      # There are no more steps in the flow, go ahead and create all the resources
      case Projects.create_project(form_data[ProjectForm]) do
        {:ok, project} -> {:noreply, push_navigate(socket, to: ~p"/projects/#{project.id}")}
        _ -> {:noreply, put_flash(socket, :error, "Could not create project resources")}
      end
    end
  end

  # Moves back to the previous step, or navigates to the `return_to` URL query if on the first
  # step. This allows the back button to be dynamic and either move steps or do a live navigation.
  def handle_event("back", params, socket) do
    prev_index = Enum.find_index(socket.assigns.steps, &(&1 == socket.assigns.current_step)) - 1
    prev_step = Enum.at(socket.assigns.steps, prev_index)

    if prev_step && prev_index >= 0 do
      {:noreply, assign(socket, :current_step, prev_step)}
    else
      {:noreply, push_navigate(socket, to: params["return_to"])}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col h-full gap-8">
      <.page_header title="Start Your Project" back_click={@back_click} class="mb-0" />

      <.progress
        variant="stepped"
        total={Enum.count(@steps)}
        current={Enum.find_index(@steps, &(&1 == @current_step)) + 1}
      />

      <div class="flex-1 relative">
        <.subform module={ProjectForm} id="project-form" current_step={@current_step} steps={@steps} />

        <.subform
          module={BatteriesForm}
          id="project-batteries-form"
          current_step={@current_step}
          steps={@steps}
        />

        <.subform module={WebForm} id="project-web-form" current_step={@current_step} steps={@steps} />

        <.subform
          module={MachineLearningForm}
          id="project-machine-learning-form"
          current_step={@current_step}
          steps={@steps}
        />

        <.subform
          module={DatabaseForm}
          id="project-database-form"
          current_step={@current_step}
          steps={@steps}
        />
      </div>
    </div>
    """
  end

  defp subform(assigns) do
    ~H"""
    <.live_component class={["h-full", @current_step != @module && "hidden"]} {assigns}>
      <.button variant="secondary" icon={:play_circle}>View Demo Video</.button>

      <.button
        :if={@current_step != Enum.at(@steps, -1)}
        variant="primary"
        icon={:arrow_right}
        icon_position={:right}
        type="submit"
      >
        Next Step
      </.button>

      <.button
        :if={@current_step == Enum.at(@steps, -1)}
        variant="primary"
        type="submit"
        phx-disable-with="Creating..."
      >
        Create Project
      </.button>
    </.live_component>
    """
  end

  # Defines the ordering of the new project subform flow

  defp steps(type) when is_binary(type), do: type |> String.to_existing_atom() |> steps()

  defp steps(:web) do
    [
      ProjectForm,
      BatteriesForm,
      WebForm
    ]
  end

  defp steps(:ml) do
    [
      ProjectForm,
      BatteriesForm,
      MachineLearningForm
    ]
  end

  defp steps(:db) do
    [
      ProjectForm,
      BatteriesForm,
      DatabaseForm
    ]
  end

  defp steps do
    [
      ProjectForm,
      BatteriesForm
    ]
  end
end
