defmodule WordList do  
  def get_score word_list, word do
    case HashDict.fetch(word_list.words, word) do
      {:ok, score} -> score
      :error -> -String.length(word) * 2
    end
  end
  
  def load_from_file file do
    stream = File.stream!(file) |>
      Enum.map(fn(line) -> 
        [word, score] = String.split(line)
        {score, _} = Integer.parse(score)
        {word, score} 
      end 
      ) |>
      Enum.into(HashDict.new)
  end

  def random_word_list name, words do
    RandomList.new name, Enum.map(words, fn({word, score})-> word end)
  end
  
  def get_word name do
    RandomList.get name
  end
end