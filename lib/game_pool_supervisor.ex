defmodule Letterex.GamePoolSupervisor do
  use Supervisor
  
  def start_link name do
    Supervisor.start_link(__MODULE__, [], name: name)
  end
  
  def init [] do
    children = [ worker(Letterex.GameSupervisor, [:game_sup]), 
                 worker(Letterex.LetterSourceSupervisor, [:letter_pool_sup])]
    supervise children, strategy: :one_for_one
  end
  
  def start_game_with_letter_pool locale do
    {:ok, pid} = Supervisor.start_child :letter_pool_sup, [locale]
    Supervisor.start_child :game_sup, [locale]
  end
end