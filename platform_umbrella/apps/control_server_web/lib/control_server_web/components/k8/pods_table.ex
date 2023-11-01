defmodule ControlServerWeb.PodsTable do
  @moduledoc false
  use ControlServerWeb, :html

  import CommonCore.Resources.FieldAccessors
  import ControlServerWeb.ResourceHTMLHelper

  defp restart_count(pod) do
    pod
    |> container_statuses()
    |> Enum.filter(& &1)
    |> Enum.reduce(0, fn cs, acc -> acc + Map.get(cs, "restartCount", 0) end)
  end

  defp age(pod) do
    case pod
         |> Map.get("status", %{})
         |> Map.get("startTime", "")
         |> Timex.parse("{ISO:Extended}") do
      {:ok, start_time} ->
        Timex.from_now(start_time)

      _ ->
        "Unknown"
    end
  end

  attr :id, :string, default: "pods-table"
  attr :pods, :list, required: true

  def pods_table(assigns) do
    ~H"""
    <.table :if={@pods != []} rows={@pods} id={@id} row_click={&JS.navigate(resource_show_path(&1))}>
      <:col :let={pod} label="Name"><%= name(pod) %></:col>
      <:col :let={pod} label="Namespace"><%= namespace(pod) %></:col>
      <:col :let={pod} label="Status"><%= phase(pod) %></:col>
      <:col :let={pod} label="Restarts"><%= restart_count(pod) %></:col>
      <:col :let={pod} label="Age"><%= age(pod) %></:col>

      <:action :let={pod}>
        <.action_icon
          to={resource_show_path(pod)}
          icon={:eye}
          tooltip="Show Pod"
          id={"show_pod_" <> to_html_id(pod)}
        />
        <.action_icon
          to={resource_show_path(pod, %{"log" => true})}
          icon={:document_text}
          tooltip="Logs"
          id={"logs_for_" <> to_html_id(pod)}
        />
      </:action>
    </.table>

    <.light_text :if={@pods == []}>No pods available</.light_text>
    """
  end
end
