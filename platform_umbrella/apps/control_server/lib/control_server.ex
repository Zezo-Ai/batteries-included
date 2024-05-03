defmodule ControlServer do
  @moduledoc """
  ControlServer keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def context do
    quote do
      import Ecto.Query, warn: false

      alias ControlServer.Repo
      alias Ecto.Changeset
      alias Ecto.Multi
    end
  end

  @doc """
  When used, dispatch to the appropriate helper.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
