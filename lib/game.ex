defmodule Letterex.Game do
  use GenServer
  require Logger
  
  defstruct locale: :en_GB, letters: nil, board: nil, 
            players: [],
            game_state: :initial,
            start_timeout: 30000,
            max_players: 4
    
  def init game_state do
    {:ok, board} = Letterex.Board.start_link
    {:ok, %{game_state | board: board}}
  end
  
  def players pid do
    GenServer.call pid, :players
  end
  
  def join pid, player do
    GenServer.call pid, {:join, player}
  end
  
  def handle_call :players, _from, state do
    %{players: players} = state
    {:reply, players, state}
  end
  
  def handle_call :board, _from, state do
    {:reply, state.board, state}
  end
  
  def handle_call {:join, player}, _from, state do
    case state.game_state do
      :started ->
        {:reply, :join_rejected, state}
      _ ->
        do_join player, state.players, state.max_players, state
    end
  end

  def handle_call msg, _from, state do
    {:reply, state}
  end
  
  # The start game timeout has fired here.
  def handle_info :start_game_timeout, state do
    Logger.info "Start game timeout sent after #{state.start_timeout} ms."
    case state.game_state do
      :started ->
        {:noreply, state}
      _ ->
        {:noreply, do_start_game(state)}
    end
  end

  def start_link game_state do
    GenServer.start_link(__MODULE__, game_state, [])
  end

  # First player joining starts a timer
  defp do_join(player, [], max_players, state) do
    Process.send_after self, :start_game_timeout, state.start_timeout 
    {:reply, :join_accepted, %{state | players: [player], game_state: :waiting}}
  end

  defp do_join(player, players, max_players, state) when length(players) == max_players - 1 do
    {:reply, :join_accepted, do_start_game(%{state | players: [player | players]})}
  end
      
  defp do_join(player, players, max_players, state) when length(players) < max_players do
    {:reply, :join_accepted, %{state | players: [player | players]}}
  end
  
  defp do_join _player, _players, _, state do
    {:reply, :join_rejected, state}
  end
  
  defp do_start_game state do
    for p <- state.players, do: GenServer.cast(p, :game_started)
    %{state | game_state: :started}
  end
end
