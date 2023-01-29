defmodule ControlServerWeb.InstalledBatteriesHook do
  import Phoenix.Component
  import KubeServices.SystemState.SummaryBatteries

  def on_mount(:installed_batteries, _params, _session, socket) do
    {:cont, assign_installed_batteries(socket, &installed_batteries/0)}
  end

  def assign_installed_batteries(socket, battery_fn) when is_function(battery_fn, 0) do
    assign_new(socket, :installed_batteries, battery_fn)
  end
end
