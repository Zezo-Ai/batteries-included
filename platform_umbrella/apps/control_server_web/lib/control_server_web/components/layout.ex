defmodule ControlServerWeb.Layout do
  use Phoenix.Component
  use PetalComponents

  alias CommonUI.Layout, as: BaseLayout

  @default_menu_item_class ["hover:bg-astral-100", "hover:text-pink-500", "text-gray-500"]
  @default_icon_class ["h-6", "w-6", "text-astral-500", "group-hover:text-pink-500"]

  defp assign_defaults(assigns) do
    assigns
    |> assign_new(:menu_item_class, fn -> @default_menu_item_class end)
    |> assign_new(:icon_class, fn -> @default_icon_class end)
    |> assign_new(:container_type, fn -> :default end)
    |> assign_new(:title, fn -> [] end)
  end

  defdelegate title(assigns), to: BaseLayout

  defp assign_icon_defaults(assigns) do
    assigns
    |> assign_new(:class, fn -> @default_icon_class end)
    |> assign_new(:type, fn -> "database" end)
  end

  defp icon(assigns) do
    assigns = assign_icon_defaults(assigns)

    ~H"""
    <%= case @type do %>
      <% "database" -> %>
        <Heroicons.Outline.database class={@class} />
      <% "beaker" -> %>
        <Heroicons.Outline.beaker class={@class} />
      <% "chart_bar" -> %>
        <Heroicons.Outline.chart_bar class={@class} />
      <% "devtools" -> %>
        <CommonUI.Icons.Devtools.render class={@class} />
      <% "globe_alt" -> %>
        <Heroicons.Outline.globe_alt class={@class} />
      <% "lock_closed" -> %>
        <Heroicons.Outline.lock_closed class={@class} />
    <% end %>
    """
  end

  def menu_item(assigns) do
    assigns = assign_defaults(assigns)

    ~H"""
    <BaseLayout.menu_item to={@to} name={@name} class={@menu_item_class}>
      <.icon class={@icon_class} type={@icon} />
    </BaseLayout.menu_item>
    """
  end

  def layout(assigns) do
    assigns = assign_defaults(assigns)

    ~H"""
    <BaseLayout.layout bg_class="bg-white" container_type={@container_type}>
      <:title>
        <%= render_slot(@title) %>
      </:title>
      <:main_menu>
        <.menu_item to="/services/database" name="Database" icon="database" />
        <.menu_item to="/services/ml" name="Machine Learning" icon="beaker" />
        <.menu_item to="/services/monitoring/settings" name="Monitoring" icon="chart_bar" />
        <.menu_item to="/services/devtools/settings" name="Devtools" icon="devtools" />
        <.menu_item to="/services/security/settings" name="Security" icon="lock_closed" />
        <.menu_item to="/services/network/settings" name="Network" icon="globe_alt" />
      </:main_menu>
      <%= render_slot(@inner_block) %>
    </BaseLayout.layout>
    """
  end
end
