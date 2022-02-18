defmodule ControlServerWeb.ServicesLive.JupyterLabNotebook.Index do
  use ControlServerWeb, :live_view

  import ControlServerWeb.Layout
  import ControlServerWeb.PodDisplay

  alias ControlServer.Notebooks
  alias ControlServer.Services
  alias ControlServer.Services.Pods
  alias ControlServerWeb.RunnableServiceList

  @pod_update_time 5000

  defp get_pods do
    Enum.map(Pods.get(), &Pods.summarize/1)
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @pod_update_time)

    {:ok,
     socket
     |> assign(:jupyter_lab_notebooks, list_jupyter_lab_notebooks())
     |> assign(:pods, get_pods())
     |> assign(:services, [
       Services.Notebooks
     ])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Jupyter lab notebooks")
    |> assign(:jupyter_lab_notebook, nil)
  end

  @impl true
  def handle_info(:update, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, @pod_update_time)

    {:noreply, assign(socket, :pods, get_pods())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    jupyter_lab_notebook = Notebooks.get_jupyter_lab_notebook!(id)
    {:ok, _} = Notebooks.delete_jupyter_lab_notebook(jupyter_lab_notebook)

    {:noreply, assign(socket, :jupyter_lab_notebooks, list_jupyter_lab_notebooks())}
  end

  def handle_event("start_notebook", _, socket) do
    with {:ok, _} <-
           Notebooks.create_jupyter_lab_notebook(%{
             image: "jupyter/datascience-notebook:lab-3.1.9"
           }) do
      {:noreply, assign(socket, :jupyter_lab_notebooks, list_jupyter_lab_notebooks())}
    end
  end

  defp list_jupyter_lab_notebooks do
    Notebooks.list_jupyter_lab_notebooks()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.layout>
      <:title>
        <.title>Jupyter Notebooks</.title>
      </:title>
      <div class="container-xxl">
        <div class="mt-4 row">
          <.live_component
            module={RunnableServiceList}
            services={@services}
            id={"ml_base_services"}
          />
        </div>
        <div class="mt-2 row">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Image</th>
                <th />
              </tr>
            </thead>
            <tbody id="jupyter_lab_notebooks">
              <%= for notebook <- @jupyter_lab_notebooks do %>
                <tr id="jupyter_lab_notebook-{jupyter_lab_notebook.id}">
                  <td>
                    <%= notebook.name %>
                  </td>
                  <td>
                    <%= notebook.image %>
                  </td>
                  <td>
                    <span>
                      <.link
                        link_type="live_redirect"
                        to={Routes.services_jupyter_lab_notebook_show_path(@socket, :index, notebook)}
                      >
                        Show
                      </.link>
                    </span>
                    <span>
                      <a href={"http://anton2:8081/x/notebooks/#{notebook.name}"}>
                        Open
                      </a>
                    </span>
                    |
                    <span>
                      <.link
                        label="Delete"
                        to="#"
                        phx-click="delete"
                        phx-value-id={notebook.id}
                        data={[confirm: "Are you sure?"]}
                      />
                    </span>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
        <div class="mt-2 row">
          <.button phx-click="start_notebook">
            Start Notebook
          </.button>
        </div>
        <div class="mt-2 row">
          <.pods_display pods={@pods} />
        </div>
      </div>
    </.layout>
    """
  end
end
