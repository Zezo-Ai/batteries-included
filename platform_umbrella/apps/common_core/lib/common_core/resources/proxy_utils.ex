defmodule CommonCore.Resources.ProxyUtils do
  @moduledoc false
  use TypedStruct

  import CommonCore.StateSummary.Namespaces

  alias CommonCore.Batteries.SystemBattery
  alias CommonCore.StateSummary

  require Logger

  @default_port 80

  @spec port(SystemBattery.t(), StateSummary.t()) :: pos_integer()
  def port(_battery, _state) do
    @default_port
  end

  @spec extension_name(SystemBattery.t(), StateSummary.t()) :: String.t()
  def extension_name(%SystemBattery{type: battery_type} = _battery, %StateSummary{} = _state) do
    "#{sanitize(battery_type)}-ext-authz-http"
  end

  def extension_name(_, _), do: nil

  @spec service_name(SystemBattery.t(), StateSummary.t()) :: String.t()
  def service_name(%SystemBattery{type: battery_type} = _battery, %StateSummary{} = _state) do
    "oauth2-proxy-#{sanitize(battery_type)}"
  end

  def service_name(_, _), do: nil

  @spec fully_qualified_service_name(SystemBattery.t(), StateSummary.t()) :: String.t()
  def fully_qualified_service_name(%SystemBattery{} = battery, %StateSummary{} = state) do
    svc = service_name(battery, state)
    namespace = core_namespace(state)
    "#{svc}.#{namespace}.svc.cluster.local"
  end

  def fully_qualified_service_name(_, _), do: nil

  @spec prefix(SystemBattery.t(), StateSummary.t()) :: String.t()
  def prefix(_, _) do
    "/oauth2"
  end

  @spec cookie_secret(SystemBattery.t(), StateSummary.t()) :: String.t()
  def cookie_secret(%SystemBattery{config: battery_config} = _battery, %StateSummary{} = _state) do
    battery_config.cookie_secret
  end

  def cookie_secret(_, _), do: nil

  def auth_policy(hosts, battery, state) do
    %{
      "action" => "CUSTOM",
      "provider" => %{"name" => extension_name(battery, state)},
      "rules" => [%{"to" => [%{"operation" => %{"hosts" => hosts}}]}]
    }
  end

  def request_auth(state) do
    uri = CommonCore.StateSummary.URLs.keycloak_uri_for_realm(state, CommonCore.Defaults.Keycloak.realm_name())

    %{
      "jwtRules" => [
        %{
          "issuer" => URI.to_string(uri),
          "jwksUri" => uri |> URI.append_path("/protocol/openid-connect/certs") |> URI.to_string()
        }
      ]
    }
  end

  @spec sanitize(atom()) :: String.t()
  def sanitize(a) when is_atom(a), do: sanitize(Atom.to_string(a))

  @spec sanitize(String.t()) :: String.t()
  def sanitize(s) do
    s
    |> String.downcase()
    |> String.replace(" ", "-")
    |> String.replace("_", "-")
  end
end
