defmodule CommonUI.Tooltip do
  @moduledoc false
  use CommonUI.Component

  attr :target_id, :string, required: true
  attr :tippy_options, :map, default: %{}
  attr :rest, :global
  slot :inner_block

  @doc """
  Tooltip component. This is a stateless component that actually has a computed id

  This component will not be visible as its' `hidden` however on mount
  it uses the Tooltip hook to create a tippy tooltip targeting the `target_id`
  element. The innerHTML is then used as the content for any tippy tooltip needed.
  """
  def tooltip(assigns) do
    ~H"""
    <div
      class="hidden"
      id={"tooltip-#{@target_id}"}
      phx-hook="Tooltip"
      data-target={@target_id}
      data-tippy-options={Jason.encode!(@tippy_options)}
    >
      <div {@rest}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :class, :string, required: false, default: ""
  slot :inner_block

  def help_question_mark(assigns) do
    ~H"""
    <div :if={@inner_block != nil && @inner_block != []} class={["cursor-pointer", @class]} id={@id}>
      <Heroicons.question_mark_circle class="w-6 h-auto" />
      <.tooltip target_id={@id}>
        <%= render_slot(@inner_block) %>
      </.tooltip>
    </div>
    """
  end

  slot :inner_block, required: true
  slot :tooltip
  attr :class, :string, default: ""
  attr :rest, :global

  def hover_tooltip(%{tooltip: []} = assigns) do
    ~H"""
    <%= render_slot(@inner_block) %>
    """
  end

  def hover_tooltip(assigns) do
    ~H"""
    <div class={["group/hover-tooltip relative", @class]} {@rest}>
      <div
        class={
          [
            # The tooltip is hidden by default and is shown when the user hovers over the element
            "invisible",
            # Group hover and focus within are used to show the tooltip when the user hovers
            "group-hover/hover-tooltip:visible group-focus-within/hover-tooltip:visible",
            # Move the tooltip up and over
            "absolute -translate-x-1 -translate-y-full",
            "rounded-md shadow-md p-2",
            "bg-white/90 text-gray-800",
            "dark:bg-gray-700/90 dark:text-white"
          ]
        }
        role="tooltip"
        aria-hidden="true"
      >
        <%= render_slot(@tooltip) %>
      </div>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
