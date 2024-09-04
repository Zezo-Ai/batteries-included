defmodule ControlServerWeb.Batteries.TrivyOperatorForm do
  @moduledoc false

  use ControlServerWeb, :live_component

  import ControlServerWeb.BatteriesFormSubcomponents

  def render(assigns) do
    ~H"""
    <div class="contents">
      <.panel title="Configuration">
        <.simple_form variant="nested">
          <.input field={@form[:version_tag]} label="Version Tag" />
        </.simple_form>
      </.panel>

      <.panel title="Image">
        <.simple_form variant="nested">
          <.image>
            <%= @form[:image].value %><br />
            <%= @form[:node_collector_image].value %><br />
            <%= @form[:trivy_checks_image].value %>
          </.image>

          <.image_version
            field={@form[:image_tag_override]}
            image_id={:trivy_operator}
            label="Version"
          />

          <.image_version
            field={@form[:node_collector_image_tag_override]}
            image_id={:aqua_node_collector}
            label="Node Collector Version"
          />

          <.image_version
            field={@form[:trivy_checks_image_tag_override]}
            image_id={:aqua_trivy_checks}
            label="Checks Version"
          />
        </.simple_form>
      </.panel>
    </div>
    """
  end
end
