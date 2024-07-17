defmodule ControlServerWeb.KnativeFormSubcomponents do
  @moduledoc false
  use ControlServerWeb, :html

  import KubeServices.SystemState.SummaryHosts

  alias Ecto.Changeset
  alias Phoenix.HTML.Form

  attr :class, :any, default: nil
  attr :form, Form, required: true

  def main_panel(assigns) do
    ~H"""
    <div class={["contents", @class]}>
      <.panel>
        <.grid columns={[sm: 1, lg: 2]}>
          <.input label="Name" field={@form[:name]} autofocus placeholder="Name" />
          <.input label="URL" name="url" value={potential_url(@form)} disabled />
        </.grid>
      </.panel>
    </div>
    """
  end

  defp potential_url(%Form{} = form) do
    "http://#{knative_host(Changeset.apply_changes(form.source))}"
  end
end
