defmodule CompileTest do
  use ExUnit.Case
  doctest Compile

  test "greets the world" do
    assert Compile.hello() == :world
  end
end
