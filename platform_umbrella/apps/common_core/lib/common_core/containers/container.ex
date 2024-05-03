defmodule CommonCore.Containers.Container do
  @moduledoc false

  use CommonCore, :embedded_schema

  import CommonCore.Util.EctoValidations

  @required_fields ~w(image name)a
  @optional_fields ~w(args command)a

  typed_embedded_schema do
    field :args, {:array, :string}, default: nil
    field :command, {:array, :string}, default: nil

    # TODO: validate that we can reach whatever registry/image/version is set
    #       in :image; at least warn if we can't
    field :image, :string
    field :name, :string

    embeds_many(:env_values, CommonCore.Containers.EnvValue, on_replace: :delete)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, Enum.concat(@required_fields, @optional_fields))
    |> validate_required(@required_fields)
    |> cast_embed(:env_values)
    |> downcase_fields([:name])
  end
end
