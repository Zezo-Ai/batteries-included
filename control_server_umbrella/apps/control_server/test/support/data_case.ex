defmodule ControlServer.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ControlServer.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias ControlServer.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import ControlServer.DataCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(ControlServer.Repo)

    unless tags[:async] do
      Sandbox.mode(ControlServer.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  def assert_config_map_good(config_map) do
    config_map
    |> Enum.each(fn {_path, resource} ->
      case resource do
        resource_list when is_list(resource_list) ->
          resource_list |> Enum.map(&assert_resouce_good/1)

        _ ->
          assert_resouce_good(resource)
      end
    end)
  end

  defp assert_resouce_good(single_resource) do
    operation = K8s.Client.create(single_resource)
    assert Map.get(operation.data, "metadata") == Map.get(single_resource, "metadata")
  end
end
