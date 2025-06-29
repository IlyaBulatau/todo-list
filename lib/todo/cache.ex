defmodule Todo.Cache do
  use GenServer

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:process, server_name}, _, servers) do
    case Map.fetch(servers, server_name) do
      {:ok, server} -> {:reply, server, servers}
      :error ->
        {:ok, server} = Todo.Server.start()
        {:reply, server, Map.put(servers, server_name, server)}
    end
  end

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def process(cache_pid, server_name) do
    GenServer.call(cache_pid, {:process, server_name})
  end
end
