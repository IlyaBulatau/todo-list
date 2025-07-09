defmodule Todo.Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def init(opts), do: opts

  def child_spec(_arg) do
    Plug.Cowboy.child_spec(
      scheme: :http,
      options: [port: 8002],
      plug: __MODULE__
    )
  end

  get "/tasks" do
    conn = Plug.Conn.fetch_query_params(conn)
    server_name = Map.fetch!(conn.params, "name")

    Todo.Cache.process(String.to_atom(server_name))

    data = Todo.Server.get_tasks(String.to_atom(server_name))
    json_data = Jason.encode!(data)

    conn |> Plug.Conn.put_resp_content_type("application/json") |> Plug.Conn.send_resp(200, json_data)
  end

end
