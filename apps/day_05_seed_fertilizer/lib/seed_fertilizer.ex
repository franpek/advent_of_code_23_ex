defmodule SeedFertilizer do
  @moduledoc """
  Documentation for `SeedFertilizer`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SeedFertilizer.get_lowest_location("./apps/day_05_seed_fertilizer/files/example.txt")
      35

    :timer.tc(SeedFertilizer, :get_lowest_location, ["./apps/day_05_seed_fertilizer/files/example.txt"])
      {2475, 35}
  """
  def get_lowest_location(path) do
    File.read!(path)
    |> String.split("\r\n\r\n", trim: true)
    |> Enum.map(&String.split(&1, [":\r\n","\r\n"]))
    |> process_sample
  end

  def process_sample( [[hd] | tl] ) do
    hd
    |> String.split(" ")
    |> tl
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&map_in_sample(&1, tl))
    |> Enum.min
  end

  def map_in_sample(number, []), do: number
  def map_in_sample(number, [ [ _ | map_ranges ] | tl]) do
    map_in_sample(process_range(number, map_ranges), tl)
  end

  def process_range(number, [hd | tl]) do
    [destination_range_start, source_range_start, range_length] =
      parse_range(hd)
    map(number, [destination_range_start, source_range_start, range_length], tl)
  end
  def process_range(number, []), do: number

  defp parse_range(range), do: range |> String.split(" ") |> Enum.map(&String.to_integer/1)

  def map(n, [x, y, z], _) when y <= n and n < (y+z), do: x+(n-y)
  def map(n, _, tl), do: process_range(n ,tl)

  @doc """
  Scratchcards.

  ## Examples

      iex> SeedFertilizer.get_new_lowest_location("./apps/day_05_seed_fertilizer/files/example.txt")
      46

  """
  def get_new_lowest_location(path) do
    File.read!(path)
    |> String.split("\r\n\r\n", trim: true)
    |> Enum.map(&String.split(&1, [":\r\n","\r\n"]))
    |> new_process_sample
  end

  def new_process_sample( [[hd] | tl] ) do
    hd
    |> String.split(" ")
    |> tl
    |> Enum.map(&String.to_integer/1)
    |> decompose_ranges
    |> Enum.map(&Enum.to_list/1)
    |> List.flatten
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&map_in_sample(&1, tl))
    |> Enum.min
  end

  def decompose_ranges([]), do: []
  def decompose_ranges([number, values | tl]), do: [number..(number+values-1) | decompose_ranges(tl)]

end