defmodule Todo.Server do
  @moduledoc """
  Модуль обратного вызова для GenServer с реализацией функций над задачами.
  Позволяет нескольким клиентам взаимодействовать с одним и тем же списком
  """

  use GenServer

  @impl GenServer
  def init({server_name, todo_list}), do: {:ok, {server_name, Todo.Database.get(server_name) || todo_list}}

  def start(server_name) do
    IO.puts("Server Started: #{server_name}")
    GenServer.start_link(__MODULE__, {server_name, %Todo.List{}}, name: server_name)
  end

  @impl GenServer
  def handle_call(:get_tasks, _, {server_name, state}) do
    {:reply, Todo.List.get_all(state), {server_name, state}}
  end

  @impl GenServer
  def handle_call({:get_task_by_id, id}, _, {server_name, state}) do
    {:reply, Todo.List.get_by_id(id, state), {server_name, state}}
  end

  @impl GenServer
  def handle_cast({:add_task, task}, {server_name, state}) do
    updated = Todo.List.add(task ,state)
    Todo.Database.save(server_name, updated)

    {:noreply, {server_name, updated}}
  end

  @impl GenServer
  def handle_cast({:remove_task, id}, {server_name, state}) do
    updated = Todo.List.remove(id, state)
    Todo.Database.save(server_name, updated)

    {:noreply, {server_name, updated}}
  end

  def add_task(pid, task) do
    GenServer.cast(pid, {:add_task, task})
  end

  def remove_task(pid, id) do
    GenServer.cast(pid, {:remove_task, id})
  end

  def get_tasks(pid) do
    GenServer.call(pid, :get_tasks)
  end

  def get_task_by_id(pid, id) do
    GenServer.call(pid, {:get_task_by_id, id})
  end

end
