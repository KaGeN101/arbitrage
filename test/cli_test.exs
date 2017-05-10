defmodule CliTest do 
  use ExUnit.Case
  import Arbitrage.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do 
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "the currency retuned that was given" do
    assert parse_args(["ABC"]) == {"ABC" }
  end

end

