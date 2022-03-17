defmodule ControlServer.Services.RunnableService do
  alias ControlServer.Repo
  alias ControlServer.Services
  alias Ecto.Multi

  require Logger

  @enforce_keys [:service_type, :path]
  defstruct service_type: nil, path: nil, config: %{}, dependencies: []

  def services,
    do: [
      # Database
      %__MODULE__{path: "/database/common", service_type: :database},
      %__MODULE__{
        path: "/database/public",
        service_type: :database_public,
        dependencies: [:database]
      },
      %__MODULE__{
        path: "/battery/database",
        service_type: :database_internal,
        dependencies: [:database]
      },
      # Battery
      %__MODULE__{path: "/battery/core", service_type: :battery},
      %__MODULE__{
        path: "/battery/control_server",
        service_type: :control_server,
        dependencies: [:battery]
      },
      %__MODULE__{path: "/battery/echo", service_type: :echo_server, dependencies: [:battery]},

      # Devtools
      %__MODULE__{path: "/devtools/knative", service_type: :knative, dependencies: [:istio]},

      # ML
      %__MODULE__{path: "/ml/core", service_type: :ml},
      %__MODULE__{path: "/ml/notebooks", service_type: :notebooks, dependencies: [:ml]},

      # Monitoring
      %__MODULE__{path: "/monitoring/prometheus_operator", service_type: :prometheus_operator},
      %__MODULE__{
        path: "/monitoring/prometheus",
        service_type: :prometheus,
        dependencies: [:prometheus_operator]
      },
      %__MODULE__{
        path: "/monitoring/grafana",
        service_type: :grafana,
        dependencies: [:prometheus]
      },
      %__MODULE__{
        path: "/monitoring/alert_manager",
        service_type: :alert_manager,
        dependencies: [:prometheus]
      },
      %__MODULE__{
        path: "/monitoring/kube_monitoring",
        service_type: :kube_monitoring,
        dependencies: [:prometheus]
      },

      # Network
      %__MODULE__{path: "/network/kong", service_type: :kong},
      %__MODULE__{path: "/network/nginx", service_type: :nginx},
      %__MODULE__{path: "/network/istio", service_type: :istio},

      # Security
      %__MODULE__{path: "/security/cert_manager", service_type: :cert_manager},
      %__MODULE__{
        path: "/security/keycloak",
        service_type: :keycloak,
        dependencies: [:database_internal]
      }
    ]

  def services_map, do: services() |> Enum.map(fn s -> {s.service_type, s} end) |> Enum.into(%{})

  def activate!(service_type) when is_atom(service_type) do
    Logger.debug("activating #{service_type}")
    runnable = Map.get(services_map(), service_type)

    Logger.debug("Runnable -> #{inspect(runnable)}")
    services_map() |> Map.get(service_type) |> activate!()
  end

  def activate!(
        %__MODULE__{
          path: path,
          service_type: service_type,
          config: config,
          dependencies: deps
        } = service
      ) do
    Multi.new()
    |> Multi.run(:dependencies, fn _repo, _state ->
      Enum.each(deps, fn s -> activate!(s) end)
      {:ok, deps}
    end)
    |> Multi.run(service_type, fn _repo, _state ->
      Services.find_or_create(%{
        root_path: path,
        service_type: service_type,
        config: config
      })
    end)
    |> Multi.run(:post, fn repo, _state ->
      run_post(service, repo)
    end)
    |> Repo.transaction()
  end

  def active?(path) when is_bitstring(path), do: Services.active?(path)

  def active?(service_type) when is_atom(service_type),
    do: services_map() |> Map.get(service_type) |> active?()

  def active?(%__MODULE__{path: path} = _service), do: Services.active?(path)

  defp run_post(%__MODULE__{service_type: :database_internal} = _service, repo) do
    ControlServer.Postgres.find_or_create(KubeRawResources.Battery.control_cluster(), repo)
  end

  defp run_post(%__MODULE__{service_type: :keycloak} = _service, repo) do
    ControlServer.Postgres.find_or_create(KubeRawResources.Keycloak.keycloak_cluster(), repo)
  end

  defp run_post(%__MODULE__{} = _service, _repo), do: {:ok, []}
end
