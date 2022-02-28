defmodule ControlServer.Notebooks.JupyterLabNotebook do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "jupyter_lab_notebooks" do
    field :image, :string, default: "jupyter/datascience-notebook:lab-3.2.9"
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(jupyter_lab_notebook, attrs) do
    jupyter_lab_notebook
    |> cast(attrs, [:name, :image])
    |> add_name()
    |> validate_required([:name, :image])
  end

  defp add_name(%Ecto.Changeset{changes: %{name: _}} = c), do: c

  defp add_name(%Ecto.Changeset{data: %{name: nil}} = changeset) do
    put_change(changeset, :name, MnemonicSlugs.generate_slug())
  end

  defp add_name(%Ecto.Changeset{data: %{name: name}} = changeset) when is_bitstring(name),
    do: changeset

  defp add_name(changeset) do
    put_change(changeset, :name, MnemonicSlugs.generate_slug())
  end
end
