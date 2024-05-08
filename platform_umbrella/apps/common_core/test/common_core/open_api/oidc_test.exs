defmodule CommonCore.OpenAPI.OIDCTest do
  use ExUnit.Case

  alias CommonCore.OpenAPI.OIDC

  @example_response """
    {
    "issuer": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master",
    "authorization_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/auth",
    "token_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/token",
    "introspection_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/token/introspect",
    "userinfo_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/userinfo",
    "end_session_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/logout",
    "frontchannel_logout_session_supported": true,
    "frontchannel_logout_supported": true,
    "jwks_uri": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/certs",
    "check_session_iframe": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/login-status-iframe.html",
    "grant_types_supported": [
      "authorization_code",
      "implicit",
      "refresh_token",
      "password",
      "client_credentials",
      "urn:ietf:params:oauth:grant-type:device_code",
      "urn:openid:params:grant-type:ciba",
      "urn:ietf:params:oauth:grant-type:token-exchange"
    ],
    "acr_values_supported": [
      "0",
      "1"
    ],
    "response_types_supported": [
      "code",
      "none",
      "id_token",
      "token",
      "id_token token",
      "code id_token",
      "code token",
      "code id_token token"
    ],
    "subject_types_supported": [
      "public",
      "pairwise"
    ],
    "id_token_signing_alg_values_supported": [
      "PS384",
      "ES384",
      "RS384",
      "HS256",
      "HS512",
      "ES256",
      "RS256",
      "HS384",
      "ES512",
      "PS256",
      "PS512",
      "RS512"
    ],
    "id_token_encryption_alg_values_supported": [
      "RSA-OAEP",
      "RSA-OAEP-256",
      "RSA1_5"
    ],
    "id_token_encryption_enc_values_supported": [
      "A256GCM",
      "A192GCM",
      "A128GCM",
      "A128CBC-HS256",
      "A192CBC-HS384",
      "A256CBC-HS512"
    ],
    "userinfo_signing_alg_values_supported": [
      "PS384",
      "ES384",
      "RS384",
      "HS256",
      "HS512",
      "ES256",
      "RS256",
      "HS384",
      "ES512",
      "PS256",
      "PS512",
      "RS512",
      "none"
    ],
    "userinfo_encryption_alg_values_supported": [
      "RSA-OAEP",
      "RSA-OAEP-256",
      "RSA1_5"
    ],
    "userinfo_encryption_enc_values_supported": [
      "A256GCM",
      "A192GCM",
      "A128GCM",
      "A128CBC-HS256",
      "A192CBC-HS384",
      "A256CBC-HS512"
    ],
    "request_object_signing_alg_values_supported": [
      "PS384",
      "ES384",
      "RS384",
      "HS256",
      "HS512",
      "ES256",
      "RS256",
      "HS384",
      "ES512",
      "PS256",
      "PS512",
      "RS512",
      "none"
    ],
    "request_object_encryption_alg_values_supported": [
      "RSA-OAEP",
      "RSA-OAEP-256",
      "RSA1_5"
    ],
    "request_object_encryption_enc_values_supported": [
      "A256GCM",
      "A192GCM",
      "A128GCM",
      "A128CBC-HS256",
      "A192CBC-HS384",
      "A256CBC-HS512"
    ],
    "response_modes_supported": [
      "query",
      "fragment",
      "form_post",
      "query.jwt",
      "fragment.jwt",
      "form_post.jwt",
      "jwt"
    ],
    "registration_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/clients-registrations/openid-connect",
    "token_endpoint_auth_methods_supported": [
      "private_key_jwt",
      "client_secret_basic",
      "client_secret_post",
      "tls_client_auth",
      "client_secret_jwt"
    ],
    "token_endpoint_auth_signing_alg_values_supported": [
      "PS384",
      "ES384",
      "RS384",
      "HS256",
      "HS512",
      "ES256",
      "RS256",
      "HS384",
      "ES512",
      "PS256",
      "PS512",
      "RS512"
    ],
    "introspection_endpoint_auth_methods_supported": [
      "private_key_jwt",
      "client_secret_basic",
      "client_secret_post",
      "tls_client_auth",
      "client_secret_jwt"
    ],
    "introspection_endpoint_auth_signing_alg_values_supported": [
      "PS384",
      "ES384",
      "RS384",
      "HS256",
      "HS512",
      "ES256",
      "RS256",
      "HS384",
      "ES512",
      "PS256",
      "PS512",
      "RS512"
    ],
    "authorization_signing_alg_values_supported": [
      "PS384",
      "ES384",
      "RS384",
      "HS256",
      "HS512",
      "ES256",
      "RS256",
      "HS384",
      "ES512",
      "PS256",
      "PS512",
      "RS512"
    ],
    "authorization_encryption_alg_values_supported": [
      "RSA-OAEP",
      "RSA-OAEP-256",
      "RSA1_5"
    ],
    "authorization_encryption_enc_values_supported": [
      "A256GCM",
      "A192GCM",
      "A128GCM",
      "A128CBC-HS256",
      "A192CBC-HS384",
      "A256CBC-HS512"
    ],
    "claims_supported": [
      "aud",
      "sub",
      "iss",
      "auth_time",
      "name",
      "given_name",
      "family_name",
      "preferred_username",
      "email",
      "acr"
    ],
    "claim_types_supported": [
      "normal"
    ],
    "claims_parameter_supported": true,
    "scopes_supported": [
      "openid",
      "web-origins",
      "acr",
      "microprofile-jwt",
      "email",
      "phone",
      "offline_access",
      "address",
      "profile",
      "roles"
    ],
    "request_parameter_supported": true,
    "request_uri_parameter_supported": true,
    "require_request_uri_registration": true,
    "code_challenge_methods_supported": [
      "plain",
      "S256"
    ],
    "tls_client_certificate_bound_access_tokens": true,
    "revocation_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/revoke",
    "revocation_endpoint_auth_methods_supported": [
      "private_key_jwt",
      "client_secret_basic",
      "client_secret_post",
      "tls_client_auth",
      "client_secret_jwt"
    ],
    "revocation_endpoint_auth_signing_alg_values_supported": [
      "PS384",
      "ES384",
      "RS384",
      "HS256",
      "HS512",
      "ES256",
      "RS256",
      "HS384",
      "ES512",
      "PS256",
      "PS512",
      "RS512"
    ],
    "backchannel_logout_supported": true,
    "backchannel_logout_session_supported": true,
    "device_authorization_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/auth/device",
    "backchannel_token_delivery_modes_supported": [
      "poll",
      "ping"
    ],
    "backchannel_authentication_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/ext/ciba/auth",
    "backchannel_authentication_request_signing_alg_values_supported": [
      "PS384",
      "ES384",
      "RS384",
      "ES256",
      "RS256",
      "ES512",
      "PS256",
      "PS512",
      "RS512"
    ],
    "require_pushed_authorization_requests": false,
    "pushed_authorization_request_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/ext/par/request",
    "mtls_endpoint_aliases": {
      "token_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/token",
      "revocation_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/revoke",
      "introspection_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/token/introspect",
      "device_authorization_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/auth/device",
      "registration_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/clients-registrations/openid-connect",
      "userinfo_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/userinfo",
      "pushed_authorization_request_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/ext/par/request",
      "backchannel_authentication_endpoint": "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/protocol/openid-connect/ext/ciba/auth"
    }
  }
  """

  describe "MTLSEndpointAliases" do
    test "encodes to JSON" do
      aliases = %OIDC.MTLSEndpointAliases{
        token_endpoint: "https://example.com/token",
        revocation_endpoint: "https://example.com/revoke"
      }

      assert {:ok, _value} = Jason.encode(aliases)
    end
  end

  describe "OIDCConfiguration" do
    test "decodes from JSON" do
      assert {:ok, parsed} =
               @example_response
               |> Jason.decode!()
               |> OIDC.OIDCConfiguration.new()

      assert parsed.registration_endpoint ==
               "http://keycloak.core.172.18.128.1.ip.batteriesincl.com/realms/master/clients-registrations/openid-connect"

      assert parsed.claim_types_supported == ["normal"]
    end
  end
end
