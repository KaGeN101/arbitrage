defmodule Arbitrage.Gather do

  @base_url "http://api.fixer.io/"

  def gather(from) do
    cache = %{from => _gather(from)["rates"]}
    _matrix cache, Enum.to_list(cache[from]) 
  end

  defp _gather currency do 
    data = HTTPoison.get! "#{@base_url}latest?base=#{currency}"
    Poison.Parser.parse! data.body
  end

  defp _matrix(cache, [head | tail]) do
    updated = Map.put cache, elem(head, 0), _gather elem(head, 0)
    _matrix updated, tail 
  end   
  defp _matrix(cache, []), do: cache

end
