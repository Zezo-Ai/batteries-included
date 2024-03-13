defmodule CommonUI.Components.Button do
  @moduledoc false
  use CommonUI, :component

  import CommonUI.Components.Icon

  attr :link, :string
  attr :link_type, :string, default: "redirect", values: ["redirect", "patch", "external"]
  attr :link_replace, :boolean, default: false

  attr :variant, :string, values: ["primary", "secondary", "dark", "icon", "icon_bordered", "minimal"]
  attr :tag, :string, default: "button"
  attr :class, :string, default: nil
  attr :icon, :atom, default: nil
  attr :icon_position, :atom, default: :left, values: [:left, :right]

  attr :rest, :global,
    default: %{
      # Most buttons are either links or use `phx-click`,
      # so change default to "button" rather than "submit".
      type: "button"
    }

  slot :inner_block

  def button(%{link: _} = assigns) do
    {link, assigns} = Map.pop(assigns, :link)
    {link_type, assigns} = Map.pop(assigns, :link_type)
    {link_replace, assigns} = Map.pop(assigns, :link_replace)

    rest =
      assigns.rest
      |> Map.delete(:type)
      |> Map.put(:href, Phoenix.LiveView.Utils.valid_destination!(link, "<.button>"))

    rest =
      if link_type in ~w(redirect patch) do
        rest
        |> Map.put("data-phx-link", link_type)
        |> Map.put("data-phx-link-state", if(link_replace, do: "replace", else: "push"))
      else
        rest
      end

    assigns
    |> Map.merge(%{tag: "a", rest: rest})
    |> button()
  end

  def button(assigns) do
    ~H"""
    <.dynamic_tag
      name={@tag}
      class={[
        "inline-flex items-center justify-center gap-2 font-semibold text-sm text-nowrap cursor-pointer disabled:cursor-not-allowed phx-submit-loading:opacity-75",
        button_class(assigns[:variant]),
        @class
      ]}
      {@rest}
    >
      <.icon
        :if={@icon && @icon_position == :left}
        class={icon_class(assigns[:variant])}
        name={@icon}
      />

      <%= render_slot(@inner_block) %>

      <.icon
        :if={@icon && @icon_position == :right}
        class={icon_class(assigns[:variant])}
        name={@icon}
      />
    </.dynamic_tag>
    """
  end

  defp button_class("primary") do
    "min-w-36 px-5 py-3 rounded-lg text-white bg-primary hover:bg-primary-dark disabled:bg-gray-lighter"
  end

  defp button_class("secondary") do
    "min-w-36 px-5 py-3 rounded-lg border border-gray-lighter dark:border-gray-darker text-gray-darker dark:text-gray-lighter bg-white dark:bg-gray-darkest hover:text-primary hover:border-primary-light disabled:text-gray disabled:hover:border-gray-lighter"
  end

  defp button_class("dark") do
    "min-w-36 px-5 py-3 rounded-lg text-white bg-gray-darkest hover:bg-gray-darker disabled:bg-gray-lighter"
  end

  defp button_class("icon") do
    "size-9 p-2 rounded-full text-gray-darker hover:text-primary hover:bg-gray-lightest/75 disabled:text-gray"
  end

  defp button_class("icon_bordered") do
    "size-9 p-1.5 rounded-full border border-gray-lighter text-primary hover:border-primary-light disabled:text-gray disabled:hover:border-gray-lighter"
  end

  defp button_class("minimal") do
    "text-gray-dark hover:text-gray disabled:text-gray-light"
  end

  defp button_class(_) do
    "text-primary hover:text-primary-dark disabled:text-gray-light"
  end

  defp icon_class(_) do
    "size-5 text-current stroke-2 pointer-events-none"
  end
end
