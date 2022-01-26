defmodule CommonUI.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # These are live view test of compontnets
      import Phoenix.LiveViewTest

      # Use the Endpoint.
      @endpoint Endpoint
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
