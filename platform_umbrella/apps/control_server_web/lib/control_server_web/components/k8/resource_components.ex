defmodule ControlServerWeb.ResourceComponents do
  @moduledoc false
  use ControlServerWeb, :html

  import CommonCore.Resources.FieldAccessors
  import CommonUI.DatetimeDisplay

  attr :class, :string, default: ""
  attr :resource, :any, required: true

  def label_panel(assigns) do
    ~H"""
    <.panel title="Labels" class={@class}>
      <.data_horizontal_plain data={labels(@resource)} />
    </.panel>
    """
  end

  attr :class, :string, default: ""
  attr :events, :any, required: true

  def events_panel(assigns) do
    ~H"""
    <.panel variant="gray" title="Events" class={@class}>
      <.table :if={@events && @events != []} rows={@events}>
        <:col :let={event} label="Reason"><%= get_in(event, ~w(reason)) %></:col>
        <:col :let={event} label="Message">
          <.truncate_tooltip value={event |> get_in(~w(message))} />
        </:col>
        <:col :let={event} label="Type"><%= get_in(event, ~w(type)) %></:col>
        <:col :let={event} label="First Time">
          <.relative_display time={event["firstTimestamp"]} />
        </:col>
        <:col :let={event} label="Last Time">
          <.relative_display time={event["lastTimestamp"]} />
        </:col>
        <:col :let={event} label="Count"><%= get_in(event, ~w(count)) %></:col>
      </.table>

      <.light_text :if={@events == []}>No events</.light_text>
    </.panel>
    """
  end

  def status_icon(%{status: status} = assigns) when status in ["true", true, :ok] do
    ~H"""
    <div class="flex items-center gap-2">
      <.icon name={:check_circle} class="w-6 h-6 text-primary-600" />
      <div class="flex-initial">
        Started
      </div>
    </div>
    """
  end

  def status_icon(assigns) do
    ~H"""
    <div class="flex items-center gap-2">
      <.icon name={:x_circle} class="w-6 h-6 text-gray-dark" />
      <div class="flex-initial">
        False
      </div>
    </div>
    """
  end

  attr :resource, :map
  attr :logs, :list

  @spec logs_modal(map()) :: Phoenix.LiveView.Rendered.t()
  def logs_modal(assigns) do
    ~H"""
    <PC.modal :if={@logs} title="Logs" max_width="xl">
      <div
        id="scroller"
        style="max-height: 70vh"
        class="max-h-full rounded-md bg-gray-lightest dark:bg-gray-darkest min-h-16"
        phx-hook="ResourceLogsModal"
      >
        <code class="block p-3 overflow-x-scroll dark:text-white">
          <p :for={line <- @logs || []} class="mb-3 leading-none whitespace-normal">
            <span class="inline-block px-2 font-mono text-sm  bg-opacity-20">
              <%= line %>
            </span>
          </p>
          <div id="anchor"></div>
        </code>
      </div>
    </PC.modal>
    """
  end
end
