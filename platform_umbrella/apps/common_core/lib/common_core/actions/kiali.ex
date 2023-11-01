defmodule CommonCore.Actions.Kiali do
  @moduledoc false

  use CommonCore.Actions.SSOClient, client_name: "kiali"

  @impl ClientConfigurator
  def configure(_battery, _state, client), do: {client, []}
end
