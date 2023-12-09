defmodule MirageMaintenance do
  @moduledoc """
  Documentation for `MirageMaintenance`.
  """

  @doc """
  Mirage maintenance get extrapolated values

  ## Examples

      iex> MirageMaintenance.get_extrapolated_values("./apps/day_09_mirage_maintenance/files/example.txt")
      114

  """
    def get_extrapolated_values(path, reverse \\ false)
    def get_extrapolated_values(path, reverse) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&parse_history(&1, reverse))
    |> Enum.sum
  end

  def parse_history(history, reverse \\ false)
  def parse_history(history, reverse) do
    sequence =
    history
    |> String.split(" ", trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end )
    |> sequence

    if reverse do
      get_previous_value(sequence)
    else
      get_next_value(sequence)
    end
  end

  def sequence(history) do
    if history |> Enum.all?(fn x -> x == 0 end) do
      [ history ]
    else
      [ history | sequence(get_differences(history)) ]
    end
  end

  def get_differences([hd | [hd2|[]] ]), do: [hd2 - hd]
  def get_differences([hd | [hd2|tl] ]), do: [hd2 - hd | get_differences([hd2|tl])]

  def get_next_value([hd | []]), do: hd |> List.last
  def get_next_value([hd | tl]), do: hd |> List.last |> (fn x -> x + get_next_value(tl) end).()

  @doc """
  Mirage maintenance get extrapolated values reverse

  ## Examples

      iex> MirageMaintenance.get_extrapolated_values_reverse("./apps/day_09_mirage_maintenance/files/example.txt")
      2

  """
  def get_extrapolated_values_reverse(path), do: get_extrapolated_values(path, true)

  def get_previous_value([hd | []]), do: hd |> hd
  def get_previous_value([hd | tl]), do: hd |> hd |> (fn x -> x - get_previous_value(tl) end).()

end
