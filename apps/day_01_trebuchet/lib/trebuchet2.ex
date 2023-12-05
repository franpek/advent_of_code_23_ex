defmodule Trebuchet2 do
  @moduledoc """
  Documentation for Trebuchet.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Trebuchet2.calibration("./apps/day_01_trebuchet/files/example2.txt")
      281

  """
  def calibration (path) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes(&1))
    |> Enum.map(&parse/1)
    |> Enum.map(&concat_numbers/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end

  def parse(["o", "n", "e" | tl]),            do: ["1" | parse(tl)]
  def parse(["t", "w", "o" | tl]),            do: ["2" | parse(tl)]
  def parse(["t", "h", "r", "e", "e" | tl]),  do: ["3" | parse(tl)]
  def parse(["f", "o", "u", "r" | tl]),       do: ["4" | parse(tl)]
  def parse(["f", "i", "v", "e" | tl]),       do: ["5" | parse(tl)]
  def parse(["s", "i", "x" | tl]),            do: ["6" | parse(tl)]
  def parse(["s", "e", "v", "e", "n" | tl]),  do: ["7" | parse(tl)]
  def parse(["e", "i", "g", "h", "t" | tl]),  do: ["8" | parse(tl)]
  def parse(["n", "i", "n", "e" | tl]),       do: ["9" | parse(tl)]

  def parse([hd | tl])  do
    cond do
      Integer.parse(hd) != :error -> [hd | parse(tl)]
      true -> parse(tl)
    end
  end
  def parse(_), do: []

  defp concat_numbers([hd]) do
    [hd]
    |> (fn [hd] -> Enum.join([hd, hd]) end).()
  end

  defp concat_numbers([hd | tl]) do
    [hd | tl]
    |> (fn [hd | tl] -> Enum.join([hd, List.last(tl)]) end).()
  end


end
