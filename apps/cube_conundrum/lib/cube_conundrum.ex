defmodule CubeConundrum do
  @moduledoc """
  Documentation for CubeConundrum.
  """

  @doc """
  Possible games

  ## Examples

      iex> CubeConundrum.possible_games("./apps/cube_conundrum/files/example.txt")
      8

  """
  def possible_games(path) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&possible_game/1)
    |> Enum.filter(fn [_|[td]] -> td == true end)
    |> Enum.map(fn [hd|_] -> hd end)
    |> Enum.sum
  end

  ## input: ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"]
  def possible_game(line) do
    line
    |> String.split(":")
    |> (fn [hd|tl] -> [ parse_game(hd) | [ possible_sets(tl) ]] end).()
  end

  ##  input: "Game 1"
  def parse_game(game) do
    game
    |> String.split(" ")
    |> (fn [_| [tlh|_]] -> tlh  end).()
    |> String.to_integer
  end

  ##  input: [" 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"]
  def possible_sets(sets) do
    sets
    |> List.to_string
    |> String.split(";")
    |> Enum.map(&possible_set/1)
    |> List.flatten
    |> Enum.member?(:error)
    |> (fn val -> not val end).()
  end

  ## input: " 3 blue, 4 red"
  def possible_set(set) do
    set
    |> String.trim
    |> String.split(", ")
    |> Enum.map(&possible_hand/1)
  end

  ### input: "15 blue"
  def possible_hand(hand) do
    hand
    |> String.split ## ["15", "blue"]
    |> head_to_integer ## [15, "blue"]
    |> is_valid
  end

  def head_to_integer([hd | tl]), do: [String.to_integer(hd)  | tl]

  ### input: [15, "blue"]
  def is_valid([hd | ["red"]]) when hd > 12, do: :error
  def is_valid([hd | ["green"]]) when hd > 13, do: :error
  def is_valid([hd | ["blue"]]) when hd > 14, do: :error
  def is_valid(_), do: :ok

  @doc """
  Power of games

  ## Examples

      iex> CubeConundrum.power_games("./apps/cube_conundrum/files/example.txt")
      2286

  """
  def power_games(path) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [_|tl] -> tl end)
    |> Enum.map(&power_game/1)
    |> Enum.sum
  end

  ### (fn [_| [tlh|_]] -> tlh  end).()

  ### ["1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"]
  def power_game([hd|_]) do
    hd
    |> String.split(["; ", ", "])
    |> Enum.map(&String.split(&1))
    |> power_set
    |> Enum.product
  end

  ### [[3, "blue"], [4, "red"], [1, "red"], [2, "green"], [6, "blue"], [2, "green"]]
  def power_set(set) do
    set
    |> Enum.sort_by(&sort_set/1, :desc)
    |> IO.inspect
    |> max_values
    |> List.flatten
    |> Enum.filter(fn x -> Integer.parse(x) != :error end)
    |> Enum.map(&String.to_integer(&1))
  end
  def sort_set([hd|_]), do: Integer.parse(hd)
  def max_values([hd|tl]), do: [Enum.find([hd|tl],fn [_|[tl]] -> tl == "red"  end),  Enum.find([hd|tl],fn [_|[tl]] -> tl == "blue"  end), Enum.find([hd|tl],fn [_|[tl]] -> tl == "green"  end)]

end
