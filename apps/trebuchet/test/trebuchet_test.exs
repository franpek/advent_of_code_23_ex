defmodule TrebuchetTest do
  use ExUnit.Case
  doctest Trebuchet

  test "greets the world" do
    assert Trebuchet.hello() == :world
  end
end
