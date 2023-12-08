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
  def get_type([x,x,x,x,x], _), do: :five_oak

  def get_type(hand = [x,x,x,x,_], joker), do: get_type_four_oak_aux(hand, joker)
  def get_type(hand = [_,x,x,x,x], joker), do: get_type_four_oak_aux(hand, joker)

  def get_type(hand = [x,x,x,y,y], joker), do: get_type_full_house_aux(hand, joker)
  def get_type(hand = [y,y,x,x,x], joker), do: get_type_full_house_aux(hand, joker)

  def get_type(hand = [x,x,x,_,_], joker), do: get_type_three_oak_aux(hand, joker)
  def get_type(hand = [_,_,x,x,x], joker), do: get_type_three_oak_aux(hand, joker)
  def get_type(hand = [_,x,x,x,_], joker), do: get_type_three_oak_aux(hand, joker)

  def get_type(hand = [x,x,y,y,_], joker), do: get_type_two_pair_aux(hand, joker)
  def get_type(hand = [x,x,_,y,y], joker), do: get_type_two_pair_aux(hand, joker)
  def get_type(hand = [_,x,x,y,y], joker), do: get_type_two_pair_aux(hand, joker)

  def get_type(hand = [x,x,_,_,_], joker), do: get_type_one_pair_aux(hand, joker)
  def get_type(hand = [_,x,x,_,_], joker), do: get_type_one_pair_aux(hand, joker)
  def get_type(hand = [_,_,x,x,_], joker), do: get_type_one_pair_aux(hand, joker)
  def get_type(hand = [_,_,_,x,x], joker), do: get_type_one_pair_aux(hand, joker)

  def get_type(hand = [_,_,_,_,_], joker), do: get_type_high_card_aux(hand, joker)

  ###########################################
  def get_type_full_house_aux(hand, joker) do
    number_of_Js = hand |> Enum.filter(fn x -> x == "J" end) |> length
    cond do
      joker and number_of_Js > 1 -> :five_oak
      joker and number_of_Js > 0 -> :four_oak
      true  -> :full_house
    end
  end

  def get_type_three_oak_aux(hand, joker) do
    case joker and "J" in hand do
      true  -> :four_oak
      false -> :three_oak
    end
  end

  def get_type_two_pair_aux(hand, joker) do
    number_of_Js = hand |> Enum.filter(fn x -> x == "J" end) |> length
    cond do
      joker and number_of_Js > 1 -> :four_oak
      joker and number_of_Js > 0 -> :full_house
      true  -> :two_pair
    end
  end

  def get_type_one_pair_aux(hand, joker) do
    case joker and "J" in hand do
      true  -> :three_oak
      false -> :one_pair
    end
  end

  def get_type_four_oak_aux(hand, joker) do
    case joker and "J" in hand do
      true  -> :five_oak
      false -> :four_oak
    end
  end

  def get_type_high_card_aux(hand, joker) do
    case joker and "J" in hand do
      true  -> :one_pair
      false -> :high_card
    end
  end

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
      5905

  """
  def get_total_winning_with_joker(path), do: get_total_winning(path, true)

end
