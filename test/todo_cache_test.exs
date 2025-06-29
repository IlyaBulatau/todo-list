defmodule TodoCacheTest do
  use ExUnit.Case

  test "cache process" do
    {:ok, cache} = Todo.Cache.start()
    ilya_cache = Todo.Cache.process(cache, "ilya")

    assert ilya_cache == Todo.Cache.process(cache, "ilya")
    assert ilya_cache != Todo.Cache.process(cache, "bob")
  end
end
