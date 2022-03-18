defmodule KubeServices.ConfigGeneratorTest do
  use ControlServer.DataCase

  alias KubeResources.ConfigGenerator
  alias ControlServer.Services.RunnableService
  alias ControlServer.Services

  require Logger

  describe "ConfigGenerator" do
    setup do
      {:ok,
       services_activate_map:
         RunnableService.services()
         |> Enum.map(fn s -> {s.service_type, RunnableService.activate!(s)} end)
         |> Enum.into(%{})}
    end

    test "materialize all the configs" do
      Services.list_base_services()
      |> Enum.each(fn service ->
        configs = ConfigGenerator.materialize(service)

        assert map_size(configs) >= 1
      end)
    end

    test "Activate database_internal" do
      RunnableService.activate!(:database_internal)
      RunnableService.activate!(:database_internal)
    end

    test "everything can turn into json" do
      Services.list_base_services()
      |> Enum.each(fn base_service ->
        configs = ConfigGenerator.materialize(base_service)

        {res, _value} = Jason.encode(configs)

        assert :ok == res
      end)
    end
  end
end
