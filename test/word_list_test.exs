defmodule WordListTest do
  use ExUnit.Case
  
  test "creating a hashdict" do
    assert %HashDict{} = WordList.new
  end
end
  