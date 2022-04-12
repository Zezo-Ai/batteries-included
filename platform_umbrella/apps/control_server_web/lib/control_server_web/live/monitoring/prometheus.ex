defmodule ControlServerWeb.Live.Prometheus do
  use ControlServerWeb, :live_view

  import ControlServerWeb.IFrame
  import ControlServerWeb.Layout

  @impl true
  def render(assigns) do
    ~H"""
    <.layout container_type={:iframe}>
      <.iframe src={KubeResources.Prometheus.url()} />
    </.layout>
    """
  end
end
