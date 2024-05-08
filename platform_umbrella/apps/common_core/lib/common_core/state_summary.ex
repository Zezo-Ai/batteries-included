defmodule CommonCore.StateSummary do
  @moduledoc """
    The StateSummary module provides a struct to store and manage system state information.

    ## Example Usage

    ```elixir
    # Create a new state summary struct
    state_summary = %CommonCore.StateSummary{}

    # Access fields
    batteries = state_summary.batteries
    postgres_clusters = state_summary.postgres_clusters

    # Update fields
    state_summary = %{state_summary | batteries: [%CommonCore.Batteries.SystemBattery{}]}

  """

  use CommonCore, {:embedded_schema, no_encode: [:kube_state, :keycloak_state]}

  alias CommonCore.Batteries.SystemBattery
  alias CommonCore.Installation

  batt_embedded_schema do
    embeds_many :batteries, SystemBattery
    embeds_many :postgres_clusters, CommonCore.Postgres.Cluster
    embeds_many :ferret_services, CommonCore.FerretDB.FerretService
    embeds_many :redis_clusters, CommonCore.Redis.FailoverCluster
    embeds_many :notebooks, CommonCore.Notebooks.JupyterLabNotebook
    embeds_many :knative_services, CommonCore.Knative.Service
    embeds_many :backend_services, CommonCore.Backend.Service
    embeds_many :ip_address_pools, CommonCore.MetalLB.IPAddressPool
    embeds_many :projects, CommonCore.Projects.Project

    embeds_one :keycloak_state, CommonCore.StateSummary.KeycloakSummary

    field :kube_state, :map, default: %{}
  end

  def target_summary(%Installation{} = installation) do
    batteries = CommonCore.Installs.Batteries.default_batteries(installation)

    %__MODULE__{}
    |> changeset(%{
      batteries: Enum.map(batteries, fn b -> %{Map.from_struct(b) | config: Map.from_struct(b.config)} end),
      postgres_clusters: CommonCore.Installs.Postgres.cluster_arg_list(batteries, installation),
      # For now we don't have projects to add to the target summary
      # once we work out inter-cluster project sharing we can add this
      projects: []
    })
    |> apply_action(:insert)
  end
end
