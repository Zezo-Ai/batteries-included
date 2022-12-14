defmodule ControlServer.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:knative_services, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :image, :string

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:knative_services, [:name])
  end
end
