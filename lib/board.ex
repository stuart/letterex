defmodule Letterex.Board do
  @rows 5
  @cols 5
  @size @rows * @cols

  defstruct letters: HashDict.new, free_spaces: []
  
  def new do
    Agent.start_link fn() -> %Letterex.Board{free_spaces: new_free_spaces} end
  end
  
  def letters board do
    Agent.get board, fn(state) -> state.letters end
  end

  def letter_at board, position do
    letters = letters(board)
    do_letter_at letters, position
  end
  
  def letter_at_grid board, row, column do
    letters = letters(board)
    do_letter_at letters, row * @cols + column
  end
  
  def letter_grid board do
    Enum.map Enum.to_list(0..@rows - 1), fn(r) -> 
      Enum.map Enum.to_list(0..@cols - 1), fn(c) ->
        letter_at_grid(board, r, c)
      end
    end
  end
  
  def free_spaces board do
    Agent.get board, fn state -> state.free_spaces end
  end
  
  def add_letter board, letter do
    Agent.update board, fn b -> do_add_letter(b, letter) end
  end
  
  def remove_letter board, position do
    Agent.get_and_update board, fn b -> do_remove_letter(b, position) end
  end
  
  def clear board do
    Agent.update board, fn _ ->
      %Letterex.Board{letters: [], free_spaces: new_free_spaces}
    end
  end
  
  defp do_add_letter(%Letterex.Board{letters: letters, free_spaces: [space | rest]}, letter) do
    letters = HashDict.put(letters, space, letter)
    %Letterex.Board{letters: letters, free_spaces: rest}
  end
    
  defp do_add_letter(%Letterex.Board{letters: letters, free_spaces: []}, _) do
    %Letterex.Board{letters: letters, free_spaces: []}
  end
  
  defp do_remove_letter(%Letterex.Board{letters: letters, free_spaces: spaces}, position) do
    case do_letter_at(letters, position) do
      " " -> {nil , %Letterex.Board{letters: letters, free_spaces: spaces}}
      letter -> 
          {letter, %Letterex.Board{letters: HashDict.delete(letters,position), 
                               free_spaces: Enum.shuffle([position | spaces])}}
    end
  end
  
  defp do_letter_at letters, position do
    case HashDict.fetch(letters, position) do
      {:ok, letter} -> letter
      :error -> " "
    end
  end
  
  defp new_free_spaces do
    :random.seed(:os.timestamp)
    Enum.to_list(0..@size - 1) |> Enum.shuffle
  end
end