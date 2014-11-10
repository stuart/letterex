defmodule Letterex.LetterSourceTest do
  use ExUnit.Case
  alias Letterex.LetterSource
  
  setup do
    {:ok, pid} = LetterSource.start_link :en_TEST
    {:ok, pid: pid} 
  end
  
  test "creates a pool with at least the minimum number of letters", ctx do
    assert LetterSource.size(ctx.pid) >= 10
  end

  test "can set the minimum pool size" do
    {:ok, pid} = LetterSource.start_link :en_TEST, 20
    assert LetterSource.size(pid) >= 20
  end
  
  test "letter returns a letter from the pool", ctx do
    letter = Agent.get ctx.pid, fn(p) -> [h |_] = p.letters; h end
    assert ^letter = LetterSource.letter(ctx.pid)
  end
  
  test "letter reduces the size of the pool by 1", ctx do
    size = LetterSource.size(ctx.pid)
    if size == 11 do
      # Extra one because the pool will be re-seeded
      LetterSource.letter(ctx.pid)
      size = LetterSource.size(ctx.pid)
    end
    LetterSource.letter(ctx.pid)
    new_size = LetterSource.size(ctx.pid)
    assert size - new_size == 1
  end
  
  test "pool gets reseeded once letters have been removed", ctx do
    for _ <- (1..10), do: LetterSource.letter(ctx.pid)
    size = LetterSource.size(ctx.pid)
    assert size >= 10
  end
end