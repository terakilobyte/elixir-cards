defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "it saves a deck of cards" do
    deck = Cards.create_deck
    binary = :erlang.term_to_binary(deck)
    assert(:ok == File.write("test_file", binary))
    assert(File.exists?("test_file"))
    File.rm!("test_file")
  end

  test "it loads a deck of cards" do
    deck = Cards.create_deck
    case Cards.save(deck, "test_file") do
      :ok -> assert(deck == Cards.load("test_file"))
      _ -> assert(false, "Couldn't save file during test")
    end
    File.rm!("test_file")
  end

end
