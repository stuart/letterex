defmodule Letterex do
  use Application

  def start(_type, _args) do
    Letterex.Supervisor.start_link()
  end
end
