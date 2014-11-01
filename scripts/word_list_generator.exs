defmodule WordListGenerator do  
  use Bitwise
  
  def raw_dump language do
    System.cmd("aspell", ["dump", "master", "-d", language])
  end
  
  def dump language do
    {words, 0} = raw_dump language
    words
  end
  
  def words language do
    dump(language) 
    |> String.split
    |> Enum.reject(fn(word)-> Regex.match?(~r{'}, word) end)
    |> Enum.reject(fn(word)-> Regex.match?(~r{[A-Z]+}, word) end)
  end
  
  def letter_score word do
    Enum.reduce String.codepoints(word), 1, fn(chr, acc) ->
      acc + score_character(chr)
    end
  end

  def length_score word do
    String.length(word) 
    |> :math.pow(0.5)
    |> Kernel.round
  end
  
  def score word do
    letter_score(word) + length_score(word)
  end
  
  def score_character(char) when char in ["e", "t", "a", "o", "i", "n", "s"] do
    1
  end
  
  def score_character(char) when char in ["h", "r", "d", "l", "c", "u"] do
    2
  end
  
  def score_character(char) when char in ["m", "w", "f", "g", "y", "p"] do
    4
  end

  def score_character(char) when char in ["b", "v", "k"] do
    8
  end
  
  def score_character(char) when char in ["j", "x", "q", "z"] do
    16
  end
  
  def score_character(_) do
    1
  end
  
  def run(language) do
    words = Enum.map(words(language), fn(word) -> {word, score(word)} end)
    IO.puts length(words)
    File.write "#{language}.wordlist", Enum.reduce(words, "", fn({word, score}, acc) -> acc <> "#{word} #{score}\n" end)
  end
end
