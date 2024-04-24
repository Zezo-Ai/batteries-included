defmodule CommonUI.Components.Form do
  @moduledoc false
  use CommonUI, :component

  import CommonUI.Components.FlashGroup
  import CommonUI.Components.Panel
  import CommonUI.Components.Typography
  import CommonUI.Gettext, warn: false

  @doc """
  Renders a simple form with a css grid based 2 column layout.

  ## Examples

      <.simple_form :let={f} for={:user} phx-change="validate" phx-submit="save">
        <.input field={{f, :email}} label="Email"/>
        <.input field={{f, :username}} label="Username" />
        <:actions>
          <.button variant="primary" type="submit">Save</.button>
        <:actions>
      </.simple_form>

  """
  attr :for, :any, default: nil, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"
  attr :variant, :string, values: ["stepped", "nested"]
  attr :flash, :map, default: %{}
  attr :title, :string, default: nil
  attr :description, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(method action)

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(%{variant: "stepped"} = assigns) do
    ~H"""
    <.form for={@for} as={@as} class={["flex flex-col h-full", @class]} novalidate {@rest}>
      <div class={["grid lg:grid-cols-[2fr,1fr] content-start flex-1 gap-4", @class]}>
        <div class="row-start-2 lg:row-start-1">
          <.panel title={@title}>
            <.simple_form variant="nested">
              <.flash_group flash={@flash} />

              <%= render_slot(@inner_block) %>
            </.simple_form>
          </.panel>
        </div>

        <div>
          <.panel :if={@description} title="Info">
            <p><%= @description %></p>
          </.panel>
        </div>
      </div>

      <div class="flex items-center justify-end gap-4">
        <%= render_slot(@actions) %>
      </div>
    </.form>
    """
  end

  def simple_form(%{variant: "nested"} = assigns) do
    ~H"""
    <div class={["grid grid-cols-1 gap-x-4 gap-y-6", @class]}>
      <%= render_slot(@inner_block) %>
    </div>

    <div class="flex items-center justify-end gap-2 mt-6">
      <%= render_slot(@actions) %>
    </div>
    """
  end

  def simple_form(assigns) do
    ~H"""
    <.form for={@for} as={@as} {@rest}>
      <.simple_form variant="nested" class={@class}>
        <.h2 :if={@title}><%= @title %></.h2>
        <.flash_group flash={@flash} />

        <%= render_slot(@inner_block) %>

        <:actions>
          <%= render_slot(@actions) %>
        </:actions>
      </.simple_form>
    </.form>
    """
  end
end
