defmodule ControlServerWeb.Common.Page do
  @moduledoc false
  use Phoenix.Component

  import CommonUI.Components.Button
  import CommonUI.Components.Container
  import CommonUI.Components.Icon
  import CommonUI.Components.Link
  import CommonUI.Components.Typography

  attr :title, :string, default: nil
  attr :back_link, :string, default: nil
  attr :back_click, :any, default: nil
  attr :class, :any, default: "mb-6"

  slot :menu
  slot :inner_block

  def page_header(assigns) do
    assigns =
      Map.put(assigns, :back_button_attrs, %{
        icon: :arrow_left,
        variant: "icon_bordered",
        class: "rounded-lg"
      })

    ~H"""
    <.flex class={["flex-wrap items-center justify-between", @class]}>
      <.flex class="items-center" gaps={%{sm: 3, lg: 4}}>
        <.button :if={@back_link} link={@back_link} {@back_button_attrs} />
        <.button :if={@back_click} phx-click={@back_click} {@back_button_attrs} />

        <.h3 :if={@title} class="text-2xl font-medium text-black dark:text-white">
          <%= @title %>
        </.h3>

        <%= render_slot(@menu) %>
      </.flex>

      <%= render_slot(@inner_block) %>
    </.flex>
    """
  end

  attr :title, :string, required: false
  attr :navigate, :string, required: false
  attr :patch, :string, required: false
  attr :href, :string, required: false

  slot :inner_block, required: false

  def bordered_menu_item(%{href: href} = assigns) when href != nil do
    ~H"""
    <.a href={@href} target="_blank">
      <.flex class="p-4 border border-gray-lighter dark:border-gray-darker rounded-xl">
        <.h5 :if={@title != nil}><%= @title %></.h5>
        <div class="font-semibold grow"><%= render_slot(@inner_block) %></div>
        <.icon name={:arrow_top_right_on_square} class="w-5 h-5 text-primary my-auto" />
      </.flex>
    </.a>
    """
  end

  def bordered_menu_item(%{patch: patch} = assigns) when patch != nil do
    ~H"""
    <.a patch={@patch}>
      <.flex class="p-4 border border-gray-lighter dark:border-gray-darker rounded-xl">
        <.h5 :if={@title != nil}><%= @title %></.h5>
        <div class="font-semibold grow"><%= render_slot(@inner_block) %></div>
        <.icon name={:arrow_right} class="w-5 h-5 text-primary my-auto" />
      </.flex>
    </.a>
    """
  end

  def bordered_menu_item(assigns) do
    ~H"""
    <.a navigate={@navigate}>
      <.flex class="p-4 border border-gray-lighter dark:border-gray-darker rounded-xl">
        <.h5 :if={@title != nil}><%= @title %></.h5>
        <div class="font-semibold grow">
          <%= render_slot(@inner_block) %>
        </div>
        <.icon name={:arrow_right} class="w-5 h-5 text-primary my-auto" />
      </.flex>
    </.a>
    """
  end

  attr :class, :string, default: ""

  slot :item, required: true do
    attr :title, :string, required: false
    attr :navigate, :string, required: false
    attr :patch, :string, required: false
  end

  @spec pills_menu(map()) :: Phoenix.LiveView.Rendered.t()
  def pills_menu(assigns) do
    ~H"""
    <.flex class={["my-4 text-gray-darkest dark:text-white text-lg", @class]}>
      <.bordered_menu_item
        :for={item <- @item}
        title={item[:title]}
        navigate={item[:navigate]}
        patch={item[:patch]}
      >
        <%= render_slot(item) %>
      </.bordered_menu_item>
    </.flex>
    """
  end
end
