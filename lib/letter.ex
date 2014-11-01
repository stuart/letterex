defmodule Letter do
  def start_link do
    Agent.start_link fn -> %{char: ' ', x: 0, y: 0} end 
  end
  
  def set_char letter, [char] do
    Agent.update letter, &(%{&1 | char: char})
  end
  
  def set_position letter, x, y do
    Agent.update letter, &(%{&1 | x: x, y: y})
  end
  
  def set_all letter, char, x, y do
    Agent.update letter, fn _ -> %{char: char, x: x, y: y} end
  end
  
  def get_char letter do
    Agent.get letter, fn v -> v.char end 
  end
end