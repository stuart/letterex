defmodule Letterex.Player do
  use GenServer

  defstruct name: "Player", score: 0, selection: []
  
  def start _ do
    {:ok, %Letterex.Player{}}
  end
  
  def handle_call _msg, _from, state do
    {:reply, nil, state}
  end
  
  def handle_cast :game_started, _from, state do
    {:noreply, state}  
  end
  
  def handle_cast _msg, _from, state do
    {:noreply, state}
  end
  
  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end
end