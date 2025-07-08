defmodule Todo.Cache do
  @moduledoc """
  Хранит коллекцию серверов для работы со списками задач.
  Отвечает за создание серверных процессов и их обнаружение.
  Является точкой входа.
  """

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
        {:ok, server} = Todo.Server.start(server_name)
        {:reply, server, Map.put(servers, server_name, server)}
    end
  end

  def start_link(_) do
    IO.puts("Cache Started")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def process(server_name) do
    GenServer.call(__MODULE__, {:process, server_name})
  end
end
