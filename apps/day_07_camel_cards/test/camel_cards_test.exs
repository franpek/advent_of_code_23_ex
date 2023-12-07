defmodule CamelCardsTest do
  use ExUnit.Case
  doctest CamelCards

  test "greets the world" do
    assert CamelCards.hello() == :world
  end
end
