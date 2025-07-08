defmodule Todo.DatabaseWorker do
  @moduledoc """
  Реализация запросов к базе
  """

  use GenServer

  @impl GenServer
  def init(_) do
    {:ok, nil}
  end

  def start_link() do
    IO.puts("Database Worker Started")
    GenServer.start_link(__MODULE__, nil)
  end

  @impl GenServer
  def handle_cast({:save, path, data}, state) do
    File.write!(path, :erlang.term_to_binary(data))
    {:noreply, state}
  end


end
