defmodule Letterex.LetterSourceSupervisor do
  use Supervisor
  
  def start_link name do
    Supervisor.start_link(__MODULE__, [], name: name)
  end
  
  def init [] do
    children = [worker(Letterex.LetterSource, [])]
    supervise children, strategy: :simple_one_for_one
  end
  
  def start_letter_pool sup do
    Supervisor.start_child sup, []
  end
end