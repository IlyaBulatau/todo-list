defmodule Todo.List do
  @moduledoc "Модуль задачи с реализацией функций (бизнес логика)"

  defstruct increment_id: 1, tasks: %{}

  def add(task, tasks_list) do
    task = Map.put(task, :id, tasks_list.increment_id)
    tasks = Map.put(tasks_list.tasks, task.id, task)

    %Todo.List{tasks: tasks, increment_id: tasks_list.increment_id + 1}
  end

  def remove(id, tasks_list) do
    tasks = Map.delete(tasks_list.tasks, id)

    %Todo.List{tasks: tasks, increment_id: tasks_list.increment_id}
  end

  def get_all(tasks_list) do
    tasks_list.tasks
  end

  def get_by_id(id, tasks_list) do
    tasks_list.tasks[id]
  end
end
