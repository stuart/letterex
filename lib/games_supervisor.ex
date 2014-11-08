defmodule Letterex.GamesSupervisor do
  use Supervisor
  
  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end
  
  def init [] do
    children = [worker(Letterex.Game, [])]
    supervise children, strategy: :simple_one_for_one
  end
  
  def start_game sup do
    Supervisor.start_child sup, []
  end
end