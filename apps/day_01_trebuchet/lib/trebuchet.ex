defmodule Trebuchet do
  @moduledoc """
  Documentation for Trebuchet.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Trebuchet.calibration("./apps/day_01_trebuchet/files/example.txt")
      142

  """
  def calibration (path) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&get_line_sum/1)
    |> Enum.sum
  end

  defp get_line_sum (line) do
    line
    |> String.graphemes
    |> Enum.filter(fn x -> Integer.parse(x) != :error end)
    |> concat_numbers
    |> String.to_integer
  end

  defp concat_numbers([hd]) do
    [hd]
    |> (fn [hd] -> Enum.join([hd, hd]) end).()
  end

  defp concat_numbers([hd | tl]) do
    [hd | tl]
    |> (fn [hd | tl] -> Enum.join([hd, List.last(tl)]) end).()
  end

end
