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

  def async_gather do
    receive do
      {sender, currency} ->
        data = HTTPoison.get! "#{@base_url}latest?base=#{currency}"
        send sender, {:ok, Poison.Parser.parse! HTTPoison.get!("#{@base_url}latest?base=#{currency}").body }
    end       
  end

  defp _matrix(cache, [head | tail]) do
    pid = spawn(Arbitrage.Gather, :async_gather, [])
    IO.puts "Gather: #{elem(head, 0)}"
    send pid, {self, elem(head, 0)}
    updated = receive do
      {:ok, message} -> Map.put cache, elem(head, 0), message
    end 
    _matrix updated, tail 
  end   
  defp _matrix(cache, []), do: cache

end
