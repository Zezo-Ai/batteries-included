defmodule CommonCore.Containers.EnvValue do
  @moduledoc false

  use CommonCore, :embedded_schema

  @required_fields ~w(name source_type)a
  @optional_fields ~w(value source_name source_key source_optional)a

  typed_embedded_schema do
    field :name, :string

    field :source_type, Ecto.Enum, values: [:value, :config, :secret], default: :value
    field :value, :string
    field :source_name, :string
    field :source_key, :string
    field :source_optional, :boolean, default: false
  end

  def changeset(struct, params \\ %{}) do
    possible_fields = Enum.concat(@required_fields, @optional_fields)

    struct
    |> cast(params, possible_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 3, max: 256)
  end
end
