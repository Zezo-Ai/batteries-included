defmodule CommonCore.Batteries.SystemBattery do
  use Ecto.Schema

  import Ecto.Changeset
  import PolymorphicEmbed

  alias CommonCore.Batteries.{
    BatteryCoreConfig,
    ControlServerConfig,
    EmptyConfig,
    GiteaConfig,
    GrafanaConfig,
    HarborConfig,
    IstioConfig,
    KialiConfig,
    KnativeOperatorConfig,
    KnativeServingConfig,
    KubeStateMetricsConfig,
    LokiConfig,
    MetalLBConfig,
    MetalLBIPPoolConfig,
    NodeExporterConfig,
    PostgresConfig,
    PromtailConfig,
    RedisConfig,
    RookConfig,
    Smtp4devConfig,
    SsoConfig,
    TrivyOperatorConfig,
    VictoriaMetricsConfig
  }

  @possible_types [
    battery_ca: EmptyConfig,
    battery_core: BatteryCoreConfig,
    cert_manager: EmptyConfig,
    control_server: ControlServerConfig,
    gitea: GiteaConfig,
    grafana: GrafanaConfig,
    harbor: HarborConfig,
    istio: IstioConfig,
    istio_csr: EmptyConfig,
    istio_gateway: EmptyConfig,
    kiali: KialiConfig,
    knative_operator: KnativeOperatorConfig,
    knative_serving: KnativeServingConfig,
    kube_monitoring: EmptyConfig,
    kube_state_metrics: KubeStateMetricsConfig,
    loki: LokiConfig,
    metallb: MetalLBConfig,
    metallb_ip_pool: MetalLBIPPoolConfig,
    node_exporter: NodeExporterConfig,
    notebooks: EmptyConfig,
    postgres: PostgresConfig,
    promtail: PromtailConfig,
    redis: RedisConfig,
    rook: RookConfig,
    smtp4dev: Smtp4devConfig,
    sso: SsoConfig,
    trivy_operator: TrivyOperatorConfig,
    trust_manager: EmptyConfig,
    victoria_metrics: VictoriaMetricsConfig
  ]

  def possible_types, do: Keyword.keys(@possible_types)

  @timestamps_opts [type: :utc_datetime_usec]
  @derive {Jason.Encoder, except: [:__meta__]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "system_batteries" do
    field(:group, Ecto.Enum,
      values: [
        :data,
        :devtools,
        :magic,
        :ml,
        :monitoring,
        :net_sec
      ]
    )

    field(:type, Ecto.Enum, values: Keyword.keys(@possible_types))

    polymorphic_embeds_one(:config, types: @possible_types, on_replace: :update)

    timestamps()
  end

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: binary() | nil,
          group: (:data | :devtools | :magic | :ml | :monitoring | :net_sec) | nil,
          type: atom(),
          config: map(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @doc false
  def changeset(system_battery, attrs) do
    system_battery
    |> cast(attrs, [:group, :type])
    |> validate_required([:group, :type])
    |> cast_polymorphic_embed(:config)
  end
end
