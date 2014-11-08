defmodule Letterex.Supervisor do
  use Supervisor
  
  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end
  
  def init locales do
    games_sup = worker(Letterex.GamesSupervisor, [], id: :games_sup)
    supervise([games_sup | word_lists], strategy: :one_for_one)
  end
  
  def word_lists do
    [worker(Letterex.WordList, [:en_GB], id: :en_GB),
     worker(Letterex.WordList, [:en_US], id: :en_US)]
  end
end