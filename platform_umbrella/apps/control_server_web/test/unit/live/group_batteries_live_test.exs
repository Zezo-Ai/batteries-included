defmodule ControlServerWeb.GroupBatteriesLiveTest do
  use Heyya.LiveTest
  use ControlServerWeb.ConnCase

  describe "magic group batteries" do
    test "can list the group batteries", %{conn: conn} do
      conn
      |> start(~p"/batteries/magic")
      |> assert_html("Magic Batteries")
      |> assert_element(~s(a[href="/magic"]))
    end
  end

  describe "ML group batteries" do
    test "can list the group batteries", %{conn: conn} do
      conn
      |> start(~p"/batteries/ml")
      |> assert_html("Machine Learning Batteries")
      |> assert_element(~s(a[href="/ml"]))
    end
  end

  describe "Data group batteries" do
    test "can list the group batteries", %{conn: conn} do
      conn
      |> start(~p"/batteries/data")
      |> assert_html("Data Batteries")
      |> assert_element(~s(a[href="/data"]))
    end
  end

  describe "DevTools group batteries" do
    test "can list the group batteries", %{conn: conn} do
      conn
      |> start(~p"/batteries/devtools")
      |> assert_html("Devtools Batteries")
      |> assert_element(~s(a[href="/devtools"]))
    end
  end

  describe "Monitoring group batteries" do
    test "can list the group batteries", %{conn: conn} do
      conn
      |> start(~p"/batteries/monitoring")
      |> assert_html("Monitoring Batteries")
      |> assert_element(~s(a[href="/devtools"]))
    end
  end

  describe "Network Security group batteries" do
    test "can list the group batteries", %{conn: conn} do
      conn
      |> start(~p"/batteries/net_sec")
      |> assert_html("Network/Security Batteries")
      |> assert_element(~s(a[href="/net_sec"]))
    end
  end
end
