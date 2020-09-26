defmodule ApiNodesWeb.NodesController do
  use ApiNodesWeb, :controller

   @doc """
      entrypoint of the controller
    """
  def index(conn, _) do
    body = %{
      node_name: Node.self(),
      connected_to: Node.list()
    }
    json(conn, body)
  end
end
