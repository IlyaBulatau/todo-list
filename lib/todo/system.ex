defmodule Todo.System do
  @moduledoc """
  Запускает систему, отвечает за отказоустойчивость приложения,
  перезапускает упавшие процессы.
  """

  use Supervisor

  @impl Supervisor
  def init(_) do
    Supervisor.init([%{id: Todo.Database, start: {Todo.Database, :start_link, [3]}}, Todo.Cache], strategy: :one_for_one)
  end
  def start_link() do
    Supervisor.start_link(__MODULE__, nil)
  end
end
