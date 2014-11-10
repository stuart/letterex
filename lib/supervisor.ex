defmodule Letterex.Supervisor do
  use Supervisor
  
  def start_link locales do
    Supervisor.start_link(__MODULE__, locales, name: :letterex_sup)
  end
  
  def init locales do
    players_sup = worker(Letterex.PlayersSupervisor, [:players_sup], id: :players_sup)
    games_sup = worker(Letterex.GamePoolSupervisor, [:game_pool_sup], id: :game_pool_sup)
    supervise([players_sup |[games_sup | word_lists(locales)]], strategy: :one_for_one)
  end
  
  defp word_lists locales do
    Enum.map locales, fn(locale) ->  
      worker Letterex.WordList, [locale], id: locale
    end
  end  
end