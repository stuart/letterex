defmodule Letterex.GameSupervisor do
  use Supervisor
  
  def start_link name do
    Supervisor.start_link(__MODULE__, [], name: name)
  end
  
  def init [] do
    children = [worker(Letterex.Game, [])]
    supervise children, strategy: :simple_one_for_one
  end
  
  def start_game sup, locale do
    Supervisor.start_child sup, [locale]
  end
end