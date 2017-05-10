defmodule GatherTest do 
  use ExUnit.Case
  import Arbitrage.Gather, only: [ gather: 1 ]

  test "correct set is returned when currency given" do
    cache = gather("USD")
    assert Enum.count(Map.keys(cache)) == 33
  end

  test "invalid currency given" do
    assert gather("AAB") == :ok
  end 
end

