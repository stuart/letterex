defmodule GameTest do
  use ExUnit.Case
  alias Letterex.Game
  
  setup do
    Letterex.WordList.start_link :en_TEST
    :ok
  end
  
  test "init sets up a letter pool" do
    {:ok, state} = Game.init [:en_TEST]
    assert is_pid(state.letters)
  end
  
  test "init sets up a board" do
    {:ok, state} = Game.init [:en_TEST]
    assert is_pid(state.board)
  end
  
  test "the game starts with no players" do
    {:ok, state} = Game.init [:en_TEST]
    assert [] = state.players
  end
  
  test "join adds a player" do
    {:ok, _state} = Game.start_link :en_TEST
  end
end