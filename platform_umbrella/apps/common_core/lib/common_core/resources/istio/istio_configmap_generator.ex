defmodule CommonCore.Resources.Istio.IstioConfigMapGenerator do
  @moduledoc false

  import CommonCore.Resources.MapUtils
  import CommonCore.StateSummary.Namespaces

  alias CommonCore.Resources.FilterResource, as: F
  alias CommonCore.StateSummary

  @default_mesh_config %{
    "defaultProviders" => %{"metrics" => ["prometheus"]},
    "enablePrometheusMerge" => true,
    "trustDomain" => "cluster.local"
  }

  def materialize(_battery, %StateSummary{} = state) do
    %{
      "meshNetworks" => Ymlr.document!(%{"networks" => %{}}),
      "mesh" => Ymlr.document!(build_mesh_config(state))
    }
  end

  defp build_mesh_config(%StateSummary{} = state) do
    namespace = istio_namespace(state)

    # partially apply so we can re-use
    battery_installed? = fn battery -> F.batteries_installed?(state, battery) end

    # generate extension providers for sso enabled batteries that are installed
    authz_ext_providers =
      CommonCore.Resources.SSO.proxy_enabled_batteries()
      |> Enum.filter(battery_installed?)
      |> Enum.map(&build_authz_ext_provider(&1, state))

    # add em to the config if sso is enabled
    @default_mesh_config
    |> Map.put("defaultConfig", %{
      "discoveryAddress" => "istiod.#{namespace}.svc.cluster.local.:15012"
    })
    |> Map.put("rootNamespace", namespace)
    |> maybe_append(battery_installed?.(:sso), "extensionProviders", authz_ext_providers)
  end

  defp build_authz_ext_provider(battery, %StateSummary{} = state) when is_atom(battery),
    do: build_authz_ext_provider(Atom.to_string(battery), state)

  defp build_authz_ext_provider(battery, %StateSummary{} = state) do
    # TODO(jdt): need to be able to interrogate which namespace a battery is installed in
    namespace = core_namespace(state)

    %{
      "name" => "#{battery}-ext-authz-http",
      "envoyExtAuthzHttp" => %{
        "service" => "oauth2-proxy-#{battery}.#{namespace}.svc.cluster.local",
        "port" => "80",
        # headers sent to the oauth2-proxy in the check request
        "includeRequestHeadersInCheck" => ["authorization", "cookie"],
        # headers sent to backend application when request is allowed.
        "headersToUpstreamOnAllow" => [
          "x-forwarded-access-token",
          "authorization",
          "path",
          "x-auth-request-user",
          "x-auth-request-email",
          "x-auth-request-access-token"
        ],
        # headers sent back to the client when request is denied.
        "headersToDownstreamOnDeny" => ["content-type", "set-cookie"]
      }
    }
  end
end
