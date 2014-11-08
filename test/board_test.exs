defmodule Letterex.BoardTest do
  use ExUnit.Case
  alias Letterex.Board
  
  setup do
    {:ok, board} = Board.new
    {:ok, board: board }
  end
  
  test "a new board starts empty", ctx do
    assert %HashDict{} = Board.letters ctx.board
    assert 25 = length(Board.free_spaces ctx.board)
  end
  
  test "add a new letter fills an empty position", ctx do
    Board.add_letter ctx.board, "a"
    assert 24 = length(Board.free_spaces ctx.board)
    assert %HashDict{} = Board.letters ctx.board
  end

  test "adding a letter when full does not add the letter but returns :ok", ctx do
    for _ <- (0..24), do: Board.add_letter(ctx.board, "a")
    assert 0 = length(Board.free_spaces ctx.board)
    assert :ok = Board.add_letter(ctx.board, "b")
  end
  
  test "remove a letter", ctx do
    [pos | _] = Board.free_spaces ctx.board
    Board.add_letter ctx.board, "a"
    assert "a" = Board.remove_letter ctx.board, pos
    assert 25 = length(Board.free_spaces ctx.board)
  end
  
  test "remove a non existing letter", ctx do
    [_ | rest] = Board.free_spaces ctx.board
    [pos | _] = rest
    Board.add_letter ctx.board, "a"
    assert nil = Board.remove_letter ctx.board, pos
    assert 24 = length(Board.free_spaces ctx.board)
  end
  
  test "clear removes all letters", ctx do
    for _ <- (0..24), do: Board.add_letter(ctx.board, "a")
    Board.clear(ctx.board)
    assert 25 = length(Board.free_spaces ctx.board)
    assert 0 = length(Board.letters ctx.board)
  end
  
  test "letter grid returns a list of lists of letters", ctx do
    for _ <- (0..24), do: Board.add_letter(ctx.board, "a")
    row = ["a","a","a","a","a"]
    assert [row,row,row,row,row] = Board.letter_grid ctx.board
  end
  
  test "letter grid with an empty board", ctx do
    row = [" "," "," "," "," "]
    assert [row,row,row,row,row] = Board.letter_grid ctx.board
  end
  
  test "letter_at returns the letter at a point in the grid", ctx do
    [pos | _] = Board.free_spaces ctx.board
    Board.add_letter ctx.board, "x"
    assert "x" = Board.letter_at ctx.board, pos
  end
  
  test "letter_at returns a blank if there is no letter at a point", ctx do
    [pos | _] = Board.free_spaces ctx.board
    assert " " = Board.letter_at ctx.board, pos
  end
end