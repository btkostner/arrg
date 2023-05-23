defmodule Arrg.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ArrgWeb.Telemetry,
      # Start the Ecto repository
      Arrg.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Arrg.PubSub},
      # Creates a task and registry for long running processes
      {DynamicSupervisor, name: Arrg.TaskSupervisor},
      {Horde.Registry, keys: :unique, members: :auto, name: Arrg.TaskRegistry},
      # Start the Endpoint (http/https)
      ArrgWeb.Endpoint
      # Start a worker by calling: Arrg.Worker.start_link(arg)
      # {Arrg.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Arrg.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl Application
  def config_change(changed, _new, removed) do
    ArrgWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
