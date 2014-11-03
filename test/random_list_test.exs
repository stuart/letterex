defmodule RandomListTest do
  use ExUnit.Case
  def fetch_items pid do
    Agent.get pid, fn(x) -> x end
  end
  
  test "new returns ok" do
    assert {:ok, _} = RandomList.new [], :foo
  end
  
  test "a new list shuffles the items in the list given" do
    list = Enum.to_list(1..52)
    {:ok, pid} = RandomList.new(list)
    {items, used_items } = fetch_items pid
    assert [] = used_items
    assert list != items # This check will fail 1 in 52! times, but who cares?
  end
  
  test "getting a random item returns one and puts it in the used list" do
    list = Enum.to_list(1..52)
    {:ok, pid} = RandomList.new(list)
    r = RandomList.get pid
    assert is_integer(r)
    {items, used_items } = fetch_items pid
    assert [^r] = used_items
    assert length(items) == 51
  end
  
  test "the list is reshuffled after half the items are used" do
    list = Enum.to_list(1..5)
    {:ok, pid}  = RandomList.new(list)
    _ = RandomList.get pid
    _ = RandomList.get pid
    _ = RandomList.get pid
    r = RandomList.get pid
    {new_items, new_used_items } = fetch_items pid
    assert length(new_items) == 4
    assert [^r] = new_used_items
  end
end