defmodule WordListTest do
  use ExUnit.Case

  test "can load from file" do
    {words, used_words} = Agent.get :en_GB, &(&1)
    assert is_list(words)
    assert is_list(used_words)
  end
  
  test "can look up a score" do
    assert 17 = WordList.score(:en_GB, "foresail")
  end
  
  test "gets a random word list" do
    assert is_binary(RandomList.get :en_GB)
  end  
end
  