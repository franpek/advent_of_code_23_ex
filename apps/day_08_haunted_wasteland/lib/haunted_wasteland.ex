defmodule HauntedWasteland do
  @moduledoc """
  Documentation for `HauntedWasteland`.
  """

  @doc """
  Haunted wasteland get required steps

  ## Examples

      iex> HauntedWasteland.get_required_steps("./apps/day_08_haunted_wasteland/files/example.txt")
      2
      iex> HauntedWasteland.get_required_steps("./apps/day_08_haunted_wasteland/files/example2.txt")
      6

  """
  def get_required_steps(path) do
    File.read!(path)
    |> String.split(["\r\n", " ", "=", "(", ")", ",", ], trim: true)
    |> (fn [hd|tl] ->
      [hd |> String.graphemes |
       Enum.chunk_every(tl, 3) |> Enum.sort |> Enum.map(fn [hd|tl] -> [ hd|>String.graphemes | tl] end) ] end).()
    |> (fn [hd | [first_node|tl] ] ->
      run(hd, [first_node|tl], first_node) end).()
  end

  def run(_instructions, _network, node, step \\ 0)
  def run(_instructions, _network, [["Z","Z","Z"], _, _], step), do: step
  def run(instructions, network, node, step) do
    new_node =
    instructions
    |> Enum.at(rem(step, length(instructions)))
    |> get_new_dir(node)
    |> get_new_node(network)

    run(instructions, network,  new_node, step+1)
  end

  def get_new_dir("L", [_, left, _]), do: left
  def get_new_dir("R", [_, _, right]), do: right

  def get_new_node(dir, network), do:  Enum.find(network, fn [hd|_] -> hd == dir |> String.graphemes end)

end
