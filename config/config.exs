use Mix.Config

config :proxy, port: System.get_env("PORT") || 8080
