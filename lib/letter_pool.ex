defmodule Letterex.LetterPool do
  def new words, min \\ 10 do
    letters = init_letters(words, min)
    Agent.start_link(fn -> %{letters: letters, words: words, min: min} end)
  end
  
  def letter pool do
    Agent.get_and_update pool, fn(p) ->
      %{letters: [h|t], words: words, min: min} = p 
      {h, %{letters: add_to_pool(t, words, min), words: words, min: min}} 
    end
  end
  
  defp init_letters words, min do
    add_to_pool [], words, min
  end
  
  # Get a random word and put it's letters into the pool.
  # This keeps the ratios of letters right.
  defp add_to_pool(pool, words, min) when length(pool) <= min do
    word = Letterex.WordList.get_word words
    :random.seed(:os.timestamp)
    add_to_pool Enum.shuffle(pool ++ String.codepoints(word)), words, min
  end
  
  defp add_to_pool(pool, _words, _min) do
    pool
  end
  
  def size pool do
    Agent.get pool, fn(%{letters: letters, words: _, min: _}) -> length(letters) end
  end
end