import Config

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :api_nodes, ApiNodesWeb.Endpoint,
  url: [host: "api.mycompany.app"],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  server: true

  # Do not print debug messages in production
config :logger, level: :debug

config :libcluster,
  topologies: [
    cluster_dns: [
      strategy: Elixir.Cluster.Strategy.DNSPoll,
      config: [
        polling_interval: 5_000,
        query: "api.mycompany.app",
        node_basename: "api"
      ]
    ]
  ]
