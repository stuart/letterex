defmodule WordListTest do
  use ExUnit.Case
  alias Letterex.WordList
  
  test "can load from file" do
    {words, used_words} = Agent.get :en_TEST, &(&1)
    assert is_list(words)
    assert is_list(used_words)
  end
  
  test "can look up a score" do
    assert 17 = WordList.score :en_TEST, "yogurt"
  end
  
  test "can get a random word" do
    word = WordList.get_word :en_TEST
    assert Enum.member? ["chateau", "chateaux", "chatelaine", "chatelaines",
     "yogurt", "yogurts", "yodeller", "yodelling",
     "yodellers","yodelled" ], word

  end
end
  