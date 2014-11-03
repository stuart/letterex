defmodule WordList do  
  # Stores the wordlist in an ets table and creates a random word list
  # The local is used as a tid for the table and a name for the
  # random word list Agent.
  def new locale do
    :ets.new locale, [:set, :named_table ]
    words = load locale
    :ets.insert locale, words
    random_word_list(words, :"#{locale}")
  end
  
  def score locale, word do
    case :ets.lookup(locale, word) do
      [{word, score}] -> score
      _ -> -String.length(word) * 2
    end
  end
  
  def load locale do
    load_from_file "#{__DIR__}/../wordlists/#{locale}.wordlist"
  end
  
  defp load_from_file file do
    stream = File.stream!(file) |>
      Enum.map(fn(line) -> 
        [word, score] = String.split(line)
        {score, _} = Integer.parse(score)
        {word, score} 
      end 
      ) 
  end

  def random_word_list words, name do
    RandomList.new Enum.map(words, fn({word, score})-> word end), name
  end
  
  def get_word name do
    RandomList.get name
  end
end