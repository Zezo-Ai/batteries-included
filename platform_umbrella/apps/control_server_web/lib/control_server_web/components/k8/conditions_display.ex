defmodule ControlServerWeb.ConditionsDisplay do
  use ControlServerWeb, :html

  attr :conditions, :list, required: true

  def conditions_display(assigns) do
    ~H"""
    <.table rows={Enum.sort_by(@conditions, &get_condition_time/1, :desc)}>
      <:col :let={condition} label="Type"><%= Map.get(condition, "type", "") %></:col>
      <:col :let={condition} label="Message"><%= Map.get(condition, "message", "") %></:col>
      <:col :let={condition} label="Time">
        <%= Timex.format!(get_condition_time(condition), "{RFC822z}") %>
      </:col>
    </.table>
    """
  end

  defp get_condition_time(condition) do
    condition
    |> Map.get_lazy("lastTransitionTime", fn -> Map.get(condition, "lastUpdateTime", "") end)
    |> Timex.parse!("{ISO:Extended:Z}")
  end
end
