defmodule LetterexTest do
  use ExUnit.Case

  test "the application is started" do
    assert :ok = Application.ensure_started(:letterex)
  end
end
