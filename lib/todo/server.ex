defmodule Todo.Server do
  @moduledoc "Модуль обратного вызова для GenServer с реализацией функций над задачами"

  use GenServer

  @impl GenServer
  def init(state), do: {:ok, state}

  def start() do
    GenServer.start(__MODULE__, %Todo.List{})
  end

  @impl GenServer
  def handle_call(:get_tasks, _, state) do
    {:reply, Todo.List.get_all(state), state}
  end

  @impl GenServer
  def handle_call({:get_task_by_id, id}, _, state) do
    {:reply, Todo.List.get_by_id(id, state), state}
  end

  @impl GenServer
  def handle_cast({:add_task, task}, state) do
    {:noreply, Todo.List.add(task ,state)}
  end

  @impl GenServer
  def handle_cast({:remove_task, id}, state) do
    {:noreply, Todo.List.remove(id, state)}
  end

  # def add_task(task) do
  def add_task(pid, task) do
    # GenServer.cast(__MODULE__, {:add_task, task})
    GenServer.cast(pid, {:add_task, task})
  end

  def remove_task(pid, id) do
  # def remove_task(id) do
    # GenServer.cast(__MODULE__, {:remove_task, id})
    GenServer.cast(pid, {:remove_task, id})
  end

  def get_tasks(pid) do
  # def get_tasks() do
    # GenServer.call(__MODULE__, :get_tasks)
    GenServer.call(pid, :get_tasks)
  end

  # def get_task_by_id(id) do
  def get_task_by_id(pid, id) do
    GenServer.call(pid, {:get_task_by_id, id})
    # GenServer.call(__MODULE__, {:get_task_by_id, id})
  end

end
