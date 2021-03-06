# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :log_reader,
  ecto_repos: [LogReader.Repo]

# Configures the endpoint
config :log_reader, LogReaderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ngkbyXmro8UThIdFXVAnpUFiOU++NAsTSCIvA6DF34xA6KKMxrCflrdvtv7sq7AD",
  render_errors: [view: LogReaderWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LogReader.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
     signing_salt: "ctSMj8I11inuAEtjcF36hgSsZ9S1W7wE"
   ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
