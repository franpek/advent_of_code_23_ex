defmodule CamelCards do
  @moduledoc """
  Documentation for `CamelCards`.
  """

  @doc """
  Camel cards get total winning

  ## Examples

      iex> CamelCards.get_total_winning("./apps/day_07_camel_cards/files/example.txt")
      6440

  """
  def get_total_winning(path, joker \\ false)
  def get_total_winning(path, joker) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, " "))
    |> sort_by_type(joker)
    |> sort_by_card(joker)
    |> IO.inspect
    |> Enum.with_index(1)
    |> Enum.map(fn { [_, _, bid] , rank }-> String.to_integer(bid) * rank  end )
    |> Enum.sum
  end
  def sort_by_type(_list, joker \\ false)
  def sort_by_type(list, joker) do
    list
    |> Enum.map(fn [hd|[tl]] -> [ (hd |> String.graphemes |> Enum.sort |> get_type(joker)), hd , tl] end)
    |> Enum.sort_by(fn [ type | _ ] -> get_type_value(type) end )
  end

  def sort_by_card(_list, joker \\ false)
  def sort_by_card(list, joker) do
    high_card  = list |> Enum.filter(fn [hd|_] -> hd == :high_card  end) |> Enum.sort(&hand_sort(&1,&2, joker))
    one_pair   = list |> Enum.filter(fn [hd|_] -> hd == :one_pair   end) |> Enum.sort(&hand_sort(&1,&2, joker))
    two_pair   = list |> Enum.filter(fn [hd|_] -> hd == :two_pair   end) |> Enum.sort(&hand_sort(&1,&2, joker))
    three_oak  = list |> Enum.filter(fn [hd|_] -> hd == :three_oak  end) |> Enum.sort(&hand_sort(&1,&2, joker))
    full_house = list |> Enum.filter(fn [hd|_] -> hd == :full_house end) |> Enum.sort(&hand_sort(&1,&2, joker))
    four_oak   = list |> Enum.filter(fn [hd|_] -> hd == :four_oak   end) |> Enum.sort(&hand_sort(&1,&2, joker))
    five_oak   = list |> Enum.filter(fn [hd|_] -> hd == :five_oak   end) |> Enum.sort(&hand_sort(&1,&2, joker))

    high_card ++ one_pair ++ two_pair ++ three_oak ++ full_house ++ four_oak ++ five_oak
  end

  ### Sort type methods

  def get_type(_hand, joker \\ false)
  ##########################################
  def get_type([x,x,x,x,x], _), do: :five_oak
  ##########################################
  def get_type([  _,"J","J","J","J"], true), do: :five_oak
  def get_type(["J","J","J","J",  _], true), do: :five_oak
  def get_type([  x,  x,  x,  x,"J"], true), do: :five_oak
  def get_type(["J",  x,  x,  x,  x], true), do: :five_oak
  # -------------------------------------- #
  def get_type([x,x,x,x,_], _), do: :four_oak
  def get_type([_,x,x,x,x], _), do: :four_oak
  ##########################################
  def get_type(["J","J","J",  y,  y], true), do: :five_oak
  def get_type([  y,  y,"J","J","J"], true), do: :five_oak
  def get_type([  x,  x,  x,"J","J"], true), do: :five_oak
  def get_type(["J","J",  x,  x,  x], true), do: :five_oak
  # -------------------------------------- #
  def get_type([  x,  x,  x,"J",  _], true), do: :four_oak
  def get_type([  x,  x,  x,  _,"J"], true), do: :four_oak
  def get_type(["J",  _,  x,  x,  x], true), do: :four_oak
  def get_type([  _,"J",  x,  x,  x], true), do: :four_oak
  def get_type([  _,"J",  x,  x,  x], true), do: :four_oak
  def get_type([  _,  x,  x,  x,"J"], true), do: :four_oak
  def get_type(["J",  x,  x,  x,  _], true), do: :four_oak
  # -------------------------------------- #
  def get_type([x,x,x,y,y], _), do: :full_house
  def get_type([y,y,x,x,x], _), do: :full_house
  ##########################################
  def get_type(["J","J","J",  _,  _], true), do: :four_oak
  def get_type([  _,  _,"J","J","J"], true), do: :four_oak
  def get_type([  _,"J","J","J",  _], true), do: :four_oak
  def get_type(["J",  _,  x,  x,  x], true), do: :four_oak
  def get_type([  _,"J",  x,  x,  x], true), do: :four_oak
  def get_type([  x,  x,  x,"J",  _], true), do: :four_oak
  def get_type([  x,  x,  x,  _,"J"], true), do: :four_oak
  # -------------------------------------- #
  def get_type([x,x,x,_,_], _), do: :three_oak
  def get_type([_,_,x,x,x], _), do: :three_oak
  def get_type([_,x,x,x,_], _), do: :three_oak
  ##########################################
  def get_type(["J","J",  y,  y,  _], true), do: :four_oak
  def get_type(["J","J",  _,  y,  y], true), do: :four_oak
  def get_type([  _,"J","J",  y,  y], true), do: :four_oak
  def get_type([  x,  x,"J","J",  _], true), do: :four_oak
  def get_type([  x,  x,  _,"J","J"], true), do: :four_oak
  def get_type([  _,  x,  x,"J","J"], true), do: :four_oak
  # -------------------------------------- #
  def get_type(["J",  x,  x,  y,  y], true), do: :full_house
  def get_type([  x,  x,"J",  y,  y], true), do: :full_house
  def get_type([  x,  x,  y,  y,"J"], true), do: :full_house
  # -------------------------------------- #
  def get_type([x,x,y,y,_], _), do: :two_pair
  def get_type([x,x,_,y,y], _), do: :two_pair
  def get_type([_,x,x,y,y], _), do: :two_pair
  ##########################################
  def get_type(["J","J",  _,  _,  _], true), do: :three_oak
  def get_type([  _,"J","J",  _,  _], true), do: :three_oak
  def get_type([  _,  _,"J","J",  _], true), do: :three_oak
  def get_type([  _,  _,  _,"J","J"], true), do: :three_oak
  # -------------------------------------- #
  def get_type([  x,  x,"J",  _,  _], true), do: :three_oak
  def get_type([  x,  x,  _,"J",  _], true), do: :three_oak
  def get_type([  x,  x,  _,  _,"J"], true), do: :three_oak
  def get_type(["J",  x,  x,  _,  _], true), do: :three_oak
  def get_type([  _,  x,  x,"J",  _], true), do: :three_oak
  def get_type([  _,  x,  x,  _,"J"], true), do: :three_oak
  def get_type(["J",  _,  x,  x,  _], true), do: :three_oak
  def get_type([  _,"J",  x,  x,  _], true), do: :three_oak
  def get_type([  _,  _,  x,  x,"J"], true), do: :three_oak
  def get_type(["J",  _,  _,  x,  x], true), do: :three_oak
  def get_type([  _,"J",  _,  x,  x], true), do: :three_oak
  def get_type([  _,  _,"J",  x,  x], true), do: :three_oak
  # -------------------------------------- #
  def get_type([x,x,_,_,_], _), do: :one_pair
  def get_type([_,x,x,_,_], _), do: :one_pair
  def get_type([_,_,x,x,_], _), do: :one_pair
  def get_type([_,_,_,x,x], _), do: :one_pair
  ##########################################
  def get_type(["J",  _,  _,  _,  _], true), do: :one_pair
  def get_type([  _,"J",  _,  _,  _], true), do: :one_pair
  def get_type([  _,  _,"J",  _,  _], true), do: :one_pair
  def get_type([  _,  _,  _,"J",  _], true), do: :one_pair
  def get_type([  _,  _,  _,  _,"J"], true), do: :one_pair
  # -------------------------------------- #
  def get_type([_,_,_,_,_], _), do: :high_card
  ##########################################


  def get_type_value(:five_oak),   do: 6
  def get_type_value(:four_oak),   do: 5
  def get_type_value(:full_house), do: 4
  def get_type_value(:three_oak),  do: 3
  def get_type_value(:two_pair),   do: 2
  def get_type_value(:one_pair),   do: 1
  def get_type_value(:high_card),  do: 0

  ### Sort hand methods

  def get_card_value(_card, joker \\ false)
  def get_card_value("A",     _), do: 14
  def get_card_value("K",     _), do: 13
  def get_card_value("Q",     _), do: 12
  def get_card_value("J", false), do: 11
  def get_card_value("J",  true), do: 1
  def get_card_value("T",     _), do: 10
  def get_card_value(  n,     _), do: String.to_integer(n)

  def hand_sort(_item1, _item2, joker \\ false)
  def hand_sort([_, hand1, _], [_, hand2, _], joker) do
    item_one = hand1 |> String.graphemes |> Enum.map(&CamelCards.get_card_value(&1, joker))
    item_two = hand2 |> String.graphemes |> Enum.map(&CamelCards.get_card_value(&1, joker))
    item_one < item_two
  end

  @doc """
  Camel cards get total winning with jokers

  ## Examples

      iex> CamelCards.get_total_winning_with_joker("./apps/day_07_camel_cards/files/example.txt")
      6440

  """
  def get_total_winning_with_joker(path), do: get_total_winning(path, true)

end
