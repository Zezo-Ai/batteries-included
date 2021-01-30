defmodule Server.Repo.Migrations.CreateKubeClusters do
  use Ecto.Migration

  def change do
    create table(:kube_clusters, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :external_uid, :string

      timestamps()
    end
  end
end
