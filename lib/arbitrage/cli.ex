defmodule Arbitrage.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions 
  that end up driving a Rover around Mars  
  """

  def run(argv) do
    argv
      |> parse_args
      |> process
  end 

   
  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a file to read, and (optionally) to be verbose or not
  Return a tuple of `{ user, project, count }`, or `:help` if help was given. 
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do
      { [ help: true ], _, _ }
        -> :help
  
      { _, [currency], _ }
        -> {currency}
   
      _ -> :help
  
    end 
  end

  def process (:help) do
    IO.puts """
    usage: arbitrage <currency>
      eg:  arbitrage ZAR
    """
    System.halt(0)
  end
  def process({currency}) do
    IO.puts "Currency to Maximise: #{currency}"
    _process currency, Arbitrage.Gather.gather currency
  end

  defp _process(_currency, cache) when cache == :ok, do: System.halt(0)
  defp _process(currency, cache) do
    IO.puts '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
    result = Arbitrage.Normalise.run currency, cache
    IO.inspect result
    IO.puts '##########################################################'    
    best = Arbitrage.Maximise.get result
    IO.puts "Currency: #{currency}"
    IO.puts "Profit: #{best[:arbitraged] - 1000.0}"
    IO.puts "Path: #{currency}->#{Enum.map(best[:path], &("#{&1}->"))}#{currency}" 
  end

end

