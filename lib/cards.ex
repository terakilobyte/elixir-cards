defmodule Cards do
  @moduledoc """
  Contains functionality to generate a deck of cards and manipulate a card deck
  and hand.
  """

  @typedoc """
  A list of strings represneting a deck of cards
  """
  @type deck :: [String.t]

  @typedoc """
  A list of strings representing a hand of cards
  """
  @type hand :: [String.t]

  @doc """
  Returns a deck of 52 cards in order from Ace - King by suit, Spades, Clubs,
  Hearts, and Diamonds

  ## Examples

      iex> deck = Cards.create_deck
      iex> Enum.count(deck)
      52

  """
  @spec create_deck :: deck()
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
     "Ten", "Jack", "Queen", "King"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end

  end

  @doc """
    Shuffles a deck of cards

  ## Examples

      iex> deck = Cards.create_deck
      iex> deck != Cards.shuffle(deck)
      true
  """
  @spec shuffle(deck) :: deck
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Saves a deck of cards to the filesystem
  """
  @spec save(deck, String.t) :: atom
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  @doc """
    Loads a deck of cards from the filesystem
  """
  @spec load(String.t) :: deck | String.t
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, :enoent} -> "Error: Invlaid file"
      _ -> "Unknown error"
    end

  end

  @doc """
  Creates a deck of cards and deals a hand of size `hand_size`.
  Return {`hand`, `deck`}

  ## Examples
      iex> {hand, deck} = Cards.create_hand(5)
      iex> Enum.filter(deck, fn card -> Enum.any?(hand, &(&1 == card))end)
      []
      iex> Enum.count(hand)
      5
      iex> Enum.count(deck)
      47
  """
  @spec create_hand(integer) :: {hand, deck}
  def create_hand(hand_size) do
      Cards.create_deck
      |> Cards.shuffle
      |> Cards.deal(hand_size)
  end

  @doc """
    Determines whether `deck` contains `card`

  ## Examples
      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true
  """
  @spec contains?(deck, String.t) :: boolean
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    `hand_size` argument indicates how many cards should be in the hand.

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]
      iex> Enum.member?(deck, List.first(hand))
      false
  """
  @spec deal(deck, integer) :: {hand, deck}
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end
end
