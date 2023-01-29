defmodule ControlServerWeb.SystemProjectLiveTest do
  use ControlServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import ControlServer.ProjectsFixtures

  defp create_system_project(_) do
    system_project = system_project_fixture()
    %{system_project: system_project}
  end

  describe "Index" do
    setup [:create_system_project]

    test "lists all system_projects", %{conn: conn, system_project: system_project} do
      {:ok, _index_live, html} = live(conn, ~p"/system_projects")

      assert html =~ "projects"
      assert html =~ system_project.description
    end
  end

  describe "Show" do
    setup [:create_system_project]

    test "displays system_project", %{conn: conn, system_project: system_project} do
      {:ok, _show_live, html} = live(conn, ~p"/system_projects/#{system_project}/show")

      assert html =~ "Project"
    end
  end
end
