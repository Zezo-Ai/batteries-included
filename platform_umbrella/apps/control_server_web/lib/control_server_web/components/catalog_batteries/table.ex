defmodule ControlServerWeb.CatalogBatteriesTable do
  @moduledoc false
  use ControlServerWeb, :html

  alias Phoenix.Naming

  defp active_check(assigns) do
    ~H"""
    <div class="flex text-shamrock-500 font-semi-bold">
      <div class="flex-initial">
        Active
      </div>
      <div class="flex-none ml-2">
        <Heroicons.check_circle class="h-6 w-6" />
      </div>
    </div>
    """
  end

  attr :battery, :any, required: true

  def start_button(assigns) do
    ~H"""
    <.button phx-click={:start} phx-value-type={@battery.type}>
      Install Battery
    </.button>
    """
  end

  defp is_active(active, type), do: Map.has_key?(active, type)

  attr :catalog_batteries, :list, required: true
  attr :system_batteries, :list, required: true
  attr :id, :string, default: "batteries-table"
  attr :rest, :global

  def catalog_batteries_table(assigns) do
    ~H"""
    <.table id={@id} rows={@catalog_batteries} {@rest}>
      <:col :let={battery} label="Type">
        <%= Naming.humanize(battery.type) %>
      </:col>
      <:col :let={battery}>
        <.help_question_mark
          :if={battery.description != nil && battery.description != ""}
          id={"battery-#{battery.type}-desc"}
        >
          <%= battery.description %>
        </.help_question_mark>
      </:col>
      <:col :let={battery} label="Group">
        <%= battery.group %>
      </:col>
      <:col :let={battery} label="Status">
        <.active_check :if={is_active(@system_batteries, battery.type)} />
      </:col>
      <:col :let={battery} label="Install">
        <.start_button :if={!is_active(@system_batteries, battery.type)} battery={battery} />
      </:col>
    </.table>
    """
  end
end
