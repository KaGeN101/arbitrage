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
    cache = Arbitrage.Gather.gather currency
    IO.inspect cache 
  end

end

