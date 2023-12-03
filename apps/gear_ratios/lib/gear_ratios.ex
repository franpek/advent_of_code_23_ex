defmodule GearRatios do
  @moduledoc """
  Documentation for `GearRatios`.
  """

  @doc """
  Gear ratios.

  ## Examples

      iex> GearRatios.gear_ratios("./apps/gear_ratios/files/example.txt")
      4361

  """
  def gear_ratios(path) do
    matrix =
      File.read!(path)
      |> String.split("\r\n")
      |> Enum.map(&String.graphemes/1)

    matrix
      |> Enum.with_index
      |> Enum.map(fn  ({line, index}) -> process_line(matrix, Enum.with_index(line), index) end)
      |> Enum.sum
  end

  def process_line(_matrix, _line, _y, _parts \\ 0, acc \\ "", adjacent \\ false)
  def process_line(matrix, [ {item, x} | [ {next_item, next_x} | tl] ], y, parts, acc, adjacent) do
    cond do
      Integer.parse(item) != :error and Integer.parse(next_item) == :error  -> process_last_number_in_line(matrix, [ {item, x} | [ {next_item, next_x} | tl] ], y, parts, acc, adjacent)
      Integer.parse(item) != :error                                         -> process_line(matrix, [{next_item, next_x} | tl], y, parts, Enum.join([acc, item]), has_adjacent_symbol(matrix, x, y, adjacent))
      true                                                                  -> process_line(matrix, [{next_item, next_x} | tl], y, parts, "", false)
    end
  end

  def process_line(matrix, [ {item, x} | _tl], y, parts, acc, adjacent) do
    cond do
      Integer.parse(item) != :error and has_adjacent_symbol(matrix, x, y, adjacent) -> parts + String.to_integer(Enum.join([acc, item]))
      true                                                                          -> parts
    end
  end

  def process_last_number_in_line(matrix, [ {item, x} | [ {next_item, next_x} | tl] ], y, parts, acc, adjacent) do
    cond do
      adjacent or has_adjacent_symbol(matrix, x, y, adjacent) == true -> process_line(matrix, [{next_item, next_x} | tl], y, parts + String.to_integer(Enum.join([acc, item])), "", false)
      true                                                            -> process_line(matrix, [{next_item, next_x} | tl], y, parts, "", false)
    end
  end

  def has_adjacent_symbol(_, _, _, adjacent \\ false)
  def has_adjacent_symbol(matrix, x, y, adjacent) do
    cond do
      adjacent == true -> adjacent
      true             -> check_adjacent(matrix, x-1, y+1) or
                          check_adjacent(matrix, x-1, y-1) or
                          check_adjacent(matrix, x-1, y  ) or
                          check_adjacent(matrix, x+1, y+1) or
                          check_adjacent(matrix, x+1, y-1) or
                          check_adjacent(matrix, x+1, y  ) or
                          check_adjacent(matrix, x+0, y+1) or
                          check_adjacent(matrix, x+0, y-1)
    end
  end

  def check_adjacent(matrix, x, y) do
    cond do
      matrix |> Enum.at(y) == nil or matrix |> Enum.at(y) |> Enum.at(x) == nil -> false
      matrix |> Enum.at(y) |> Enum.at(x) == "." -> false
      matrix |> Enum.at(y) |> Enum.at(x) |> Integer.parse != :error -> false
      true -> true
    end
  end


  @doc """
  Gear ratios.

  ## Examples

      iex> GearRatios.gear_ratios_two("./apps/gear_ratios/files/example.txt")
      467835

  """
  def gear_ratios_two(path) do
    matrix = File.read!(path)
             |> String.split("\r\n")
             |> Enum.map(&String.graphemes/1)
    matrix
      |> Enum.with_index
      |> Enum.map(fn  ({line, index}) -> process_matrix_lines(matrix, Enum.with_index(line), index) end)
      |> Enum.sum
  end

  def process_matrix_lines(_matrix, _line, _y, _parts \\ 0)
  def process_matrix_lines(matrix, [ {"*", x} | tl ], y, parts), do: process_matrix_lines(matrix, tl, y, parts + gear_ratio(matrix, x, y))
  def process_matrix_lines(matrix, [ _ | tl ], y, parts), do: process_matrix_lines(matrix, tl, y, parts)
  def process_matrix_lines(_matrix, _tl, _y, parts), do: parts

  def gear_ratio(matrix, x, y) do
    adjacent =
      [get_number_in_matrix(matrix, x-1, y+0),
      get_number_in_matrix(matrix, x-1, y+1),
      get_number_in_matrix(matrix, x+0, y+1),
      get_number_in_matrix(matrix, x+1, y+1),
      get_number_in_matrix(matrix, x+1, y+0),
      get_number_in_matrix(matrix, x+1, y-1),
      get_number_in_matrix(matrix, x+0, y-1),
      get_number_in_matrix(matrix, x-1, y-1)]
      |> Enum.uniq
      |> Enum.filter(fn x -> x != nil end)
      |> Enum.map(&String.to_integer/1)

      cond do
        length(adjacent) == 2 -> Enum.product(adjacent)
        true -> 0
      end
  end

  def get_number_in_matrix(matrix, x, y) do
    cond do
      matrix |> Enum.at(y) == nil or matrix |> Enum.at(y) |> Enum.at(x) == nil  -> nil
      matrix |> Enum.at(y) |> Enum.at(x) |> Integer.parse != :error             -> get_number_in_line(matrix |> Enum.at(y), x-1, :left) <>
                                                                                     (matrix |> Enum.at(y) |> Enum.at(x)) <>
                                                                                   get_number_in_line(matrix |> Enum.at(y), x+1, :right)
      true -> nil
    end
  end

  def get_number_in_line(line, index, direction, acc \\ "")
  def get_number_in_line(line, index, :left, acc) do
    item = Enum.at(line, index)
    cond do
      item != nil and item != "" and Integer.parse(item) != :error  -> get_number_in_line(line, index-1, :left, Enum.at(line, index) <> acc)
      true -> acc
    end
  end
  def get_number_in_line(line, index, :right, acc) do
    item = Enum.at(line, index)
    cond do
      item != nil and item != "" and Integer.parse(item) != :error -> get_number_in_line(line, index+1, :right, acc <> Enum.at(line, index))
      true -> acc
    end
  end

end