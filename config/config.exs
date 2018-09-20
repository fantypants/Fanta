# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fanta,
  ecto_repos: [Fanta.Repo]

# Configures the endpoint
config :fanta, FantaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dffIyWnnidN/J2CH8IFdtoF2r55SyyFsl1NzOO72nmlb6wYWiXsQhmgAbHz3JS7p",
  render_errors: [view: FantaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Fanta.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
