defmodule ApiNodes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)
    IO.inspect(topologies: topologies)
    children = [
      # add libcluster supervisor
      {Cluster.Supervisor, [topologies, [name: ApiNodes.ClusterSupervisor]]},
      # Start the Telemetry supervisor
      ApiNodesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ApiNodes.PubSub},
      # Start the Endpoint (http/https)
      ApiNodesWeb.Endpoint
      # Start a worker by calling: ApiNodes.Worker.start_link(arg)
      # {ApiNodes.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ApiNodes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ApiNodesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
