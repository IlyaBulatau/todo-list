defmodule TodoCacheTest do
  use ExUnit.Case

  test "cache process" do
    new_user = Todo.Cache.process(:new_user)

    assert new_user == Todo.Cache.process(:new_user)
    assert new_user != Todo.Cache.process(:bob)
  end
end
