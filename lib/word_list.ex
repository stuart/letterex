defmodule Letterex.WordList do

  def start_link locale do
    words = load locale
    setup_ets_table locale, words
    {:ok, pid} = random_word_list words
    Process.register(pid, locale)
    {:ok, pid}
  end
  
  # Returns the score associated with a word
  def score locale, word do
    case :ets.lookup(locale, word) do
      [{_, score}] -> score
      _ -> -String.length(word) * 2
    end
  end
  
  def load locale do
    load_from_file "#{__DIR__}/../wordlists/#{locale}.wordlist"
  end
  
  defp load_from_file file do
    File.stream!(file) |>
      Enum.map(fn(line) -> 
        [word, score] = String.split(line)
        {score, _} = Integer.parse(score)
        {word, score} 
      end 
      ) 
  end

  defp setup_ets_table locale, words do
    case :ets.info(locale) do
      :undefined -> 
        :ets.new locale, [:set, :named_table ]
        :ets.insert locale, words
      _ -> 
        {:error, :already_started}
    end
  end
  
  def random_word_list words do
    Letterex.RandomList.start_link Enum.map(words, fn({word, _})-> word end)
  end
  
  def get_word pid do
    Letterex.RandomList.get pid
  end
end