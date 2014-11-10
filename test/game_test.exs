defmodule GameTest do
  use ExUnit.Case
  alias Letterex.Game
  
  setup do
    :ok
  end
  
  test "start sets up a letter source" do
    {:ok, pid} = Letterex.LetterSource.start_link :en_TEST
    {:ok, state} = Game.init %Letterex.Game{locale: :en_TEST, letters: pid}
    assert pid == state.letters
  end
  
  test "start sets up a board" do
    {:ok, state} = Game.init %Letterex.Game{locale: :en_TEST}
    assert is_pid(state.board)
  end
  
  test "the game starts with no players" do
    {:ok, state} =  Game.init %Letterex.Game{locale: :en_TEST}
    assert [] = state.players
  end
  
  test "join adds a player" do
    {:ok, game} = Game.start_link %Letterex.Game{locale: :en_TEST}
    {:ok, player} = Letterex.Player.start_link 
    assert :join_accepted = Game.join game, player
    assert Game.players(game) == [player]
  end
  
  test "join fails when the game is full" do
    {:ok, game} = Game.start_link %Letterex.Game{locale: :en_TEST}
    assert :join_accepted = Game.join game, self
    assert :join_accepted = Game.join game, self
    assert :join_accepted = Game.join game, self
    assert :join_accepted = Game.join game, self
    assert_receive {:"$gen_cast", :game_started}, 200 
    assert :join_rejected = Game.join game, self
    assert Game.players(game) == [self, self, self, self]
  end
  
  test "once a player joins the start timer starts running" do
    {:ok, game} = Game.start_link %Letterex.Game{locale: :en_TEST, start_timeout: 100}
    assert :join_accepted = Game.join game, self
    assert_receive {:"$gen_cast", :game_started}, 200 
  end
end