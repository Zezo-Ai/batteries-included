defmodule CommonCore.Postgres.PGUser do
  use TypedEctoSchema
  import Ecto.Changeset
  import CommonCore.Postgres

  @primary_key false
  @derive Jason.Encoder
  typed_embedded_schema do
    field :username, :string
    field :roles, {:array, :string}, default: []
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :roles])
    |> validate_required([:username, :roles])
    |> validate_pg_rolelist(:roles)
  end
end
