defmodule Todo.Database do
  @moduledoc """
  Управляет пуллом коннектов к базе, предоставляет интерфейс для запросов
  """

  use GenServer

  @file_dir "./persist"

  @impl GenServer
  def init(pool_size) do
    File.mkdir_p!(@file_dir)
    connections = Enum.map(1..pool_size, fn _ ->
      {:ok, pid} = Todo.DatabaseWorker.start_link
      pid
    end)
    {:ok, connections}
  end

  def start_link(pool_size) do
    IO.puts("Database Started")
    GenServer.start_link(__MODULE__, pool_size, name: __MODULE__)
  end

  @impl GenServer
  def handle_call({:get, key}, _, state) do
    data = key |> file_path |> File.read |> case do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      _ -> nil
    end
    {:reply, data, state}
  end

  @impl GenServer
  def handle_cast({:save, key, data}, state) do
    state |> get_worker |> GenServer.cast({:save, file_path(key), data})
    {:noreply, state}
  end

  defp file_path(key) do
    Path.join(@file_dir, to_string(key))
  end

  def save(key, data) do
    GenServer.cast(__MODULE__, {:save, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  defp get_worker(connections) do
    Enum.random(connections)
  end

end
