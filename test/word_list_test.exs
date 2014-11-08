defmodule WordListTest do
  use ExUnit.Case
  alias Letterex.WordList
  
  test "can load from file" do
    {:ok, pid} = WordList.start_link :en_TEST
    {words, used_words} = Agent.get pid, &(&1)
    assert is_list(words)
    assert is_list(used_words)
  end
  
  test "can look up a score" do
    {:ok, _pid} = WordList.start_link :en_TEST 
    assert 17 = WordList.score :en_TEST, "yogurt"
  end
  
  test "can get a random word" do
    {:ok, pid} = WordList.start_link :en_TEST
    word = WordList.get_word pid
    assert Enum.member? ["chateau", "chateaux", "chatelaine", "chatelaines",
     "yogurt", "yogurts", "yodeller", "yodelling",
     "yodellers","yodelled" ], word

  end
end
  