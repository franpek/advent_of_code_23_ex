defmodule CamelCards do
  @moduledoc """
  Documentation for `CamelCards`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> CamelCards.get_total_winning("./apps/day_07_camel_cards/files/example.txt")
      6592

  """
  def get_total_winning(path) do
    File.read!(path)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, " "))
    |> sort_by_type
    |> sort_by_card
    |> Enum.with_index(1)
    |> Enum.map(fn { [_, _, bid] , rank }-> String.to_integer(bid) * rank  end )
    |> Enum.sum
  end

  def sort_by_type(list) do
    list
    |> Enum.map(fn [hd|[tl]] -> [ (hd |> String.graphemes |> Enum.sort |> get_type), hd , tl] end)
    |> Enum.sort_by(fn [ type | _ ] -> get_type_value(type) end )
  end

  def sort_by_card(list) do
    high_card  = list |> Enum.filter(fn [hd|_] -> hd == :high_card  end) |> Enum.sort(&hand_sort(&1,&2))
    one_pair   = list |> Enum.filter(fn [hd|_] -> hd == :one_pair   end) |> Enum.sort(&hand_sort(&1,&2))
    two_pair   = list |> Enum.filter(fn [hd|_] -> hd == :two_pair   end) |> Enum.sort(&hand_sort(&1,&2))
    three_oak  = list |> Enum.filter(fn [hd|_] -> hd == :three_oak  end) |> Enum.sort(&hand_sort(&1,&2))
    full_house = list |> Enum.filter(fn [hd|_] -> hd == :full_house end) |> Enum.sort(&hand_sort(&1,&2))
    four_oak   = list |> Enum.filter(fn [hd|_] -> hd == :four_oak   end) |> Enum.sort(&hand_sort(&1,&2))
    five_oak   = list |> Enum.filter(fn [hd|_] -> hd == :five_oak   end) |> Enum.sort(&hand_sort(&1,&2))

    high_card ++ one_pair ++ two_pair ++ three_oak ++ full_house ++ four_oak ++ five_oak
  end

  ### Sort type methods
  
  def get_type([x,x,x,x,x]), do: :five_oak
  def get_type([x,x,x,x,_]), do: :four_oak
  def get_type([_,x,x,x,x]), do: :four_oak
  def get_type([x,x,x,y,y]), do: :full_house
  def get_type([y,y,x,x,x]), do: :full_house
  def get_type([x,x,x,_,_]), do: :three_oak
  def get_type([_,_,x,x,x]), do: :three_oak
  def get_type([_,x,x,x,_]), do: :three_oak
  def get_type([x,x,y,y,_]), do: :two_pair
  def get_type([x,x,_,y,y]), do: :two_pair
  def get_type([_,x,x,y,y]), do: :two_pair
  def get_type([x,x,_,_,_]), do: :one_pair
  def get_type([_,x,x,_,_]), do: :one_pair
  def get_type([_,_,x,x,_]), do: :one_pair
  def get_type([_,_,_,x,x]), do: :one_pair
  def get_type([_,_,_,_,_]), do: :high_card

  def get_type_value(:five_oak),   do: 6
  def get_type_value(:four_oak),   do: 5
  def get_type_value(:full_house), do: 4
  def get_type_value(:three_oak),  do: 3
  def get_type_value(:two_pair),   do: 2
  def get_type_value(:one_pair),   do: 1
  def get_type_value(:high_card),  do: 0

  ### Sort hand methods
  
  def get_card_value("A"), do: 14
  def get_card_value("K"), do: 13
  def get_card_value("Q"), do: 12
  def get_card_value("J"), do: 11
  def get_card_value("T"), do: 10
  def get_card_value(n),   do: String.to_integer(n)
  
  def hand_sort([_, hand1, _], [_, hand2, _]) do
    item_one = hand1 |> String.graphemes |> Enum.map(&CamelCards.get_card_value/1)
    item_two = hand2 |> String.graphemes |> Enum.map(&CamelCards.get_card_value/1)
    item_one < item_two
  end

  

end
