defmodule ControlServerWeb.Live.OllamaFormComponent do
  @moduledoc false

  use ControlServerWeb, :live_component

  import ControlServerWeb.OllamaFormSubcomponents

  alias CommonCore.Ollama.ModelInstance
  alias ControlServer.Ollama
  alias ControlServer.Projects
  alias Ecto.Changeset
  alias KubeServices.SystemState.SummaryBatteries

  def mount(socket) do
    {:ok,
     socket
     |> assign_new(:namespace, fn -> SummaryBatteries.ai_namespace() end)
     |> assign_projects()}
  end

  def update(assigns, socket) do
    project_id = Map.get(assigns.model_instance, :project_id) || assigns[:project_id]
    changeset = ModelInstance.changeset(assigns.model_instance, %{project_id: project_id})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_changeset(changeset)}
  end

  def handle_event("validate", %{"model_instance" => params}, socket) do
    changeset =
      socket.assigns.model_instance
      |> ModelInstance.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_changeset(socket, changeset)}
  end

  def handle_event("save", %{"model_instance" => params}, socket) do
    save_model_instance(socket, socket.assigns.action, params)
  end

  defp save_model_instance(socket, :new, params) do
    case Ollama.create_model_instance(params) do
      {:ok, model_instance} ->
        {:noreply,
         socket
         |> put_flash(:global_success, "Model successfully created")
         |> push_navigate(to: ~p"/model_instances/#{model_instance.id}/show")}

      {:error, %Changeset{} = changeset} ->
        {:noreply, assign_changeset(socket, changeset)}
    end
  end

  defp save_model_instance(socket, :edit, params) do
    case Ollama.update_model_instance(socket.assigns.model_instance, params) do
      {:ok, model_instance} ->
        {:noreply,
         socket
         |> put_flash(:global_success, "Model successfully updated")
         |> push_navigate(to: ~p"/model_instances/#{model_instance.id}/show")}

      {:error, %Changeset{} = changeset} ->
        {:noreply, assign_changeset(socket, changeset)}
    end
  end

  defp assign_projects(socket) do
    assign(socket, projects: Projects.list_projects())
  end

  defp assign_changeset(socket, changeset) do
    changeset = maybe_update_virtual_size(changeset, Changeset.get_change(changeset, :model))

    assign(socket,
      changeset: changeset,
      form: to_form(changeset)
    )
  end

  # if there's no model change, nothing to do
  defp maybe_update_virtual_size(changeset, model) when is_nil(model), do: changeset

  # model changed. check to make sure we've got a reasonable preset size
  defp maybe_update_virtual_size(changeset, model),
    do:
      maybe_update_virtual_size_based_on_sizing(
        changeset,
        ModelInstance.model_size(model),
        Changeset.get_field(changeset, :memory_requested)
      )

  # if the model is bigger than the preset, get the smallest preset that makes sense
  defp maybe_update_virtual_size_based_on_sizing(cs, model_size, memory_requested) when model_size > memory_requested,
    do: Changeset.change(cs, %{virtual_size: model_size |> ModelInstance.get_preset_for_size() |> Map.get(:name)})

  # otherwise, we're good e.g. user selected large preset and a small model
  defp maybe_update_virtual_size_based_on_sizing(cs, _model_size, _memory_requested), do: cs

  def render(assigns) do
    ~H"""
    <div>
      <.form
        novalidate
        id={@id}
        for={@form}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
      >
        <.page_header
          title={@title}
          back_link={
            if @action == :new,
              do: ~p"/model_instances",
              else: ~p"/model_instances/#{@model_instance}/show"
          }
        >
          <.button variant="dark" type="submit" phx-disable-with="Saving…">
            Save Model
          </.button>
        </.page_header>

        <.grid columns={[sm: 1, lg: 2]}>
          <.panel>
            <.model_form form={@form} action={@action} />
          </.panel>
          <.panel variant="gray">
            <.details_form form={@form} projects={@projects} />
          </.panel>
        </.grid>
      </.form>
    </div>
    """
  end
end
