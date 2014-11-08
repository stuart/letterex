defmodule Letterex.LetterPoolTest do
  use ExUnit.Case
  alias Letterex.LetterPool
  
  setup do
    Letterex.WordList.start_link(:en_TEST)
    {:ok, pid} = LetterPool.new :en_TEST
    {:ok, pid: pid} 
  end
  
  test "new creates a pool with at least the minimum number of letters", ctx do
    assert LetterPool.size(ctx.pid) >= 10
  end

  test "letter returns a letter from the pool", ctx do
    letter = Agent.get ctx.pid, fn(p) -> [h |_] = p.letters; h end
    assert ^letter = LetterPool.letter(ctx.pid)
  end
  
  test "letter reduces the size of the pool by 1", ctx do
    size = LetterPool.size(ctx.pid)
    if size == 11 do
      # Extra one because the pool will be re-seeded
      LetterPool.letter(ctx.pid)
      size = LetterPool.size(ctx.pid)
    end
    LetterPool.letter(ctx.pid)
    new_size = LetterPool.size(ctx.pid)
    assert size - new_size == 1
  end
  
  test "pool gets reseeded once letters have been removed", ctx do
    for _ <- (1..10), do: LetterPool.letter(ctx.pid)
    size = LetterPool.size(ctx.pid)
    assert size >= 10
  end
end