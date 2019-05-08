# In this file, we load production configuration and
# secrets from environment variables. You can also
# hardcode secrets, although such is generally not
# recommended and you have to remember to add this
# file to your .gitignore.
use Mix.Config

secret_key_base = "61uqNcxlas+1IXm1EtAZdaqpyHRHppayMvFupMACR/cElpydwDITNgA6JXEXTHru"

config :api, ApiWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  secret_key_base: secret_key_base
