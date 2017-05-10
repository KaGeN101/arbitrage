defmodule NormaliseTest do 
  use ExUnit.Case
  import Arbitrage.Normalise, only: [ run: 2 ]

  test "current normalisation is done on currency" do
    paths = run "USD", %{"HKD" => %{"AUD" => 0.17473, "USD" => 0.4321}, "USD" => %{"HKD" => 0.1234}, currencies: ["HKD"]} 
    assert paths["USD_HKD"][:arbitraged] == 53.32113999999999
  end

end
