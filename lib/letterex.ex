defmodule Letterex do
  require Logger
  
  def start(_type, args) do
    Logger.info "--+-- Starting Letterex --+--"    
    {:ok, pid} = Letterex.Supervisor.start_link(args)
  end
  
  def start_game locale do
    Letterex.GamePoolSupervisor.start_game_with_letter_pool locale
  end
end
