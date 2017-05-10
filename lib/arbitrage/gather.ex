defmodule Arbitrage.Gather do

  @base_url "http://api.fixer.io/"

  # Gather all the currency conversions available in the from table
  # It does this asynch
  def gather(from) do
    _check from, _gather(from)["rates"] 
  end

  defp _check(_from, gathered) when gathered == nil, do: IO.puts "Invalid Base!"
  defp _check from, gathered do
    cache = %{from => gathered, currencies: []}
    return = _matrix cache, Enum.to_list(cache[from])
    IO.inspect return
    return
  end   

  defp _gather currency do
    data = HTTPoison.get! "#{@base_url}latest?base=#{currency}"
    Poison.Parser.parse! data.body
  end  

  def async_gather do
    receive do
      {sender, currency} ->
        send sender, {:ok, Poison.Parser.parse! HTTPoison.get!("#{@base_url}latest?base=#{currency}").body }
    end       
  end

  defp _matrix(cache, [head | tail]) do
    pid = spawn(Arbitrage.Gather, :async_gather, [])
    IO.puts "Gather: #{elem(head, 0)}"
    send pid, {self(), elem(head, 0)}
    updated = receive do
      {:ok, message} -> 
        Map.put(cache, elem(head, 0), message["rates"])
    end 
    updated = Map.put updated, :currencies, updated[:currencies] ++ [elem(head, 0)]
    _matrix updated, tail 
  end   
  defp _matrix(cache, []), do: cache

end
