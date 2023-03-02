defmodule ControlServerWeb.Live.TrivyReportsIndex do
  use ControlServerWeb, {:live_view, layout: :fresh}

  import ControlServerWeb.VulnerabilityReportTable
  import ControlServerWeb.ConfigAuditReportTable
  import ControlServerWeb.RBACReportTable
  import ControlServerWeb.InfraAssessmentReportTable
  import CommonUI.TabBar

  alias EventCenter.KubeState, as: KubeEventCenter
  alias KubeExt.KubeState

  require Logger

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    live_action = socket.assigns.live_action
    subscribe(live_action)

    {:ok,
     socket
     |> assign(:objects, objects(live_action))
     |> assign(:page_title, title_text(live_action))}
  end

  defp subscribe(resource_type) do
    :ok = KubeEventCenter.subscribe(resource_type)
  end

  @impl Phoenix.LiveView
  def handle_info(_unused, socket) do
    {:noreply, assign(socket, :objects, objects(socket.assigns.live_action))}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _url, socket) do
    live_action = socket.assigns.live_action

    {:noreply,
     socket
     |> assign(:objects, objects(live_action))
     |> assign(:page_title, title_text(live_action))}
  end

  defp objects(type) do
    type
    |> KubeState.get_all()
    |> Enum.sort_by(fn r -> get_in(r, ~w(report summary highCount)) end, :desc)
    |> Enum.sort_by(fn r -> get_in(r, ~w(report summary criticalCount)) end, :desc)
  end

  defp title_text(:aqua_config_audit_report) do
    "Audit Report"
  end

  defp title_text(:aqua_cluster_rbac_assessment_report) do
    "Cluster RBAC Report"
  end

  defp title_text(:aqua_rbac_assessment_report) do
    "RBAC Report"
  end

  defp title_text(:aqua_infra_assessment_report) do
    "Kube Infra Report"
  end

  defp title_text(:aqua_vulnerability_report) do
    "Vulnerability Report"
  end

  defp tabs(selected) do
    [
      {"Audit", ~p"/trivy_reports/config_audit_report", :aqua_config_audit_report == selected},
      {"Cluster RBAC", ~p"/trivy_reports/cluster_rbac_assessment_report",
       :aqua_cluster_rbac_assessment_report == selected},
      {"RBAC", ~p"/trivy_reports/rbac_assessment_report",
       :aqua_rbac_assessment_report == selected},
      {"Kube Infra", ~p"/trivy_reports/infra_assessment_report",
       :aqua_infra_assessment_report == selected},
      {"Vulnerability", ~p"/trivy_reports/vulnerability_report",
       :aqua_vulnerability_report == selected}
    ]
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.tab_bar tabs={tabs(@live_action)} />
    <%= case @live_action do %>
      <% :aqua_config_audit_report -> %>
        <.config_audit_reports_table reports={@objects} />
      <% :aqua_cluster_rbac_assessment_report -> %>
        <.cluster_rbac_reports_table reports={@objects} />
      <% :aqua_rbac_assessment_report -> %>
        <.rbac_reports_table reports={@objects} />
      <% :aqua_infra_assessment_report -> %>
        <.infra_assessment_reports_table reports={@objects} />
      <% :aqua_vulnerability_report -> %>
        <.vulnerability_reports_table reports={@objects} />
    <% end %>
    """
  end
end
