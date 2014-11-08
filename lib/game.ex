defmodule Letterex.Game do
  use GenServer

  def init [locale] do
    {:ok, letter_pool} = Letterex.LetterPool.new(locale)
    {:ok, board}       = Letterex.Board.new
    {:ok, %{locale: locale, letters: letter_pool, board: board, players: []}}
  end
  
  def handle_call _msg, _from, state do
    {:reply, nil, state}
  end
  
  def handle_cast msg, _from, state do
    {:no_reply, state}
  end
  
  def start_link locale do
    GenServer.start_link(__MODULE__, [locale], [])
  end
end
