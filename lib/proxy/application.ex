defmodule Proxy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    port = Application.get_env(:proxy, :port)

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Proxy,
        options: [
          port: port
        ]
      ),
      Proxy.Logger.Producer,
      Proxy.Logger.Processor
    ]

    Logger.info("App Started on Port #{port}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Proxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
