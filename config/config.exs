# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :arrg,
  ecto_repos: [Arrg.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :arrg, ArrgWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  compress: false,
  live_view: [signing_salt: "o5lIn4j9"],
  pubsub_server: Arrg.PubSub,
  render_errors: [
    formats: [html: ArrgWeb.ErrorHTML, json: ArrgWeb.ErrorJSON],
    layout: false
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(script/main.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=style/main.css
      --output=../priv/static/assets/main.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

try do
  import_config "#{config_env()}.secret.exs"
rescue
  File.Error -> :noop
end
