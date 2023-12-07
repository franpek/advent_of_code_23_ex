defmodule WaitForIt do
  @moduledoc """
  Documentation for `WaitForIt`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> WaitForIt.product_of_ways_to_record("./apps/day_06_wait_for_it/files/example.txt")
      288

  """
  def product_of_ways_to_record(path) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&tl/1)
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
    |> (fn [hd | [tl]] -> Enum.zip(hd, tl) end).()
    |> Enum.map(&get_ways_to_record/1)
    |> Enum.map(&length/1)
    |> Enum.product
  end

  def get_ways_to_record({time, distance}), do: 0..time |> Enum.map(&does_record(&1, time, distance)) |> Enum.filter(fn i -> i == true end)
  def does_record(number, time, distance), do: (time-number)*number > distance

  @doc """
  Hello world.

  ## Examples

      iex> WaitForIt.real_ways_to_record("./apps/day_06_wait_for_it/files/example.txt")
      71503

  """
  def real_ways_to_record(path) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&Enum.filter(&1, fn x -> Integer.parse(x) != :error end))
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer/1)
    |> (fn [hd|[tl]] -> get_ways_to_record({hd, tl}) end).()
    |> length
  end

end

