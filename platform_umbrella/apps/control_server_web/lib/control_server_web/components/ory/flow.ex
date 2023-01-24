defmodule ControlServerWeb.Ory.Flow do
  use ControlServerWeb, :html
  import CommonUI.Form

  attr(:ui, :any, required: true)

  def flow_form(assigns) do
    ~H"""
    <form action={Map.get(@ui, "action")} method={Map.get(@ui, "method")}>
      <.flow_node
        :for={node <- Map.get(@ui, "nodes", [])}
        attributes={Map.get(node, "attributes", %{})}
        meta={Map.get(node, "meta", %{})}
        type={Map.get(node, "type", nil)}
        messages={Map.get(node, "messages", [])}
      />

      <div :if={Map.get(@ui, "messages", nil) != nil} class="form-control">
        <.error :for={msg <- Map.get(@ui, "messages", [])} message={Map.get(msg, "text")} />
      </div>
    </form>
    """
  end

  defp flow_node(%{type: "text"} = assigns) do
    ~H"""
    <div data-testid={"node/text/#{Map.get(@attributes, "id")}"}>
      <p
        :if={get_in(@meta, ~w(label text)) != nil and get_in(@meta, ~w(label text)) != ""}
        style="margin-bottom: .5rem"
        class="typography-paragraph"
        data-testid={"node/text/#{Map.get(@attributes, "id")}/label"}
      >
        <%= get_in(@meta, ~w(label text)) %>
      </p>
      <pre>
        <code data-testid={"node/text/#{Map.get(@attributes, "id")}/text"}>
          <%= Map.get(@attributes, ~w(text text)) %>
        </code>
      </pre>
    </div>
    """
  end

  defp flow_node(%{type: "input", attributes: %{"type" => "hidden"}} = assigns) do
    ~H"""
    <input type="hidden" name={Map.get(@attributes, "name")} value={Map.get(@attributes, "value")} />
    """
  end

  defp flow_node(%{type: "input", attributes: %{"type" => "checkbox"}} = assigns) do
    ~H"""
    <div class="form-control">
      <input type="hidden" name={Map.get(@attributes, "name")} value="false" />
      <input
        type="checkbox"
        name={Map.get(@attributes, "name")}
        class="toggle toggle-primary"
        value="true"
        checked={Map.get(@attributes, "value")}
      />
      <%= @label %>
      <.error :for={msg <- @messages} message={Map.get(msg, "text")} />
    </div>
    """
  end

  defp flow_node(%{type: "input", attributes: %{"type" => "button"}} = assigns) do
    ~H"""
    <.button
      name={Map.get(@attributes, "name")}
      onclick={Map.get(@attributes, "onclick")}
      value={Map.get(@attributes, "value")}
    >
      <%= get_in(@meta, ~w(label text)) %>
    </.button>
    """
  end

  defp flow_node(%{type: "input", attributes: %{"type" => "submit"}} = assigns) do
    ~H"""
    <.button
      type="submit"
      name={Map.get(@attributes, "name")}
      onclick={Map.get(@attributes, "onclick")}
      value={Map.get(@attributes, "value")}
    >
      <%= get_in(@meta, ~w(label text)) %>
    </.button>
    """
  end

  defp flow_node(%{type: "input", attributes: %{"type" => _}} = assigns) do
    ~H"""
    <div class="form-control">
      <.label><%= get_in(@meta, ~w(label text)) %></.label>
      <input
        type={Map.get(@attributes, "type")}
        name={Map.get(@attributes, "name")}
        id={Map.get(@attributes, "name")}
        value={Map.get(@attributes, "value")}
        class={[border("input", @messages), "input input-md inptut-bordered"]}
      />
      <.error :for={msg <- @messages} message={Map.get(msg, "text")} />
    </div>
    """
  end

  defp flow_node(%{} = assigns) do
    ~H"""

    """
  end

  defp border(type, [] = _errors), do: "#{type}-bordered"

  defp border(type, [_ | _] = _errors),
    do: "#{type}-bordered #{type}-error"
end
