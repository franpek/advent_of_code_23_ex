defmodule Scratchcards do
  @moduledoc """
  Documentation for `Scratchcards`.
  """

  @doc """
  Scratchcards.

  ## Examples

      iex> Scratchcards.get_points("./apps/scratchcards/files/example.txt")
      13

  """
  def get_points(path) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, [": "," | "], trim: true))
    |> Enum.map(&get_points_from_line/1)
    |> Enum.sum
  end

  def get_points_from_line( [ _ | [winning_nums | [nums]]] ) do
    winning_nums_graphemes = winning_nums |> String.split(" ")

    String.split(nums, " ", trim: true)
    |> Enum.map(&Enum.member?(winning_nums_graphemes, &1))
    |> Enum.filter(fn x -> x == true end)
    |> length
    |> get_points_from_length
  end

  def get_points_from_length(0), do: 0
  def get_points_from_length(1), do: 1
  def get_points_from_length(x), do: String.to_integer("1" <> add_zeros(x-1), 2)

  def add_zeros(0), do: ""
  def add_zeros(x), do: "0" <> add_zeros(x-1)

  @doc """
  Scratchcards.

  ## Examples

      iex> Scratchcards.get_real_points("./apps/scratchcards/files/example.txt")
      30

  """
  def get_real_points(path) do
    File.read!(path) |> String.split("\r\n")
    |> Enum.map(&String.split(&1, [": "," | "], trim: true))
    |> Enum.map( fn [_ | tl] -> [ 1 | tl] end )
    |> get_real_points_from_list
  end

  def get_real_points_from_list( [ [instance | _ ] | [] ]), do: instance
  def get_real_points_from_list( [ [instance, winning_nums | [nums] ] | tl ]) do
    winning_nums_gphs =
      winning_nums
      |> String.split(" ")

      String.split(nums, " ", trim: true)
      |> Enum.filter(fn x -> Enum.member?(winning_nums_gphs, x) end)
      |> length
      |> (fn length -> increment_instances(tl, instance, length) end).()
      |> (fn updated_tail -> instance + get_real_points_from_list(updated_tail) end).()
  end

  def increment_instances(list, _, num_of_matches) when num_of_matches == 0, do: list
  def increment_instances([[hd|tl] | tl2] , instance , num_of_matches),
      do: [[ (hd + instance) | tl] | increment_instances(tl2, instance, (num_of_matches - 1))]

end
