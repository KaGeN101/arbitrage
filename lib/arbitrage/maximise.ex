defmodule Arbitrage.Maximise do

  def get paths do
    _get Map.keys(paths), paths, %{arbitraged: -1}
  end

  defp _get [key | tail], paths, max do
    new_max = if paths[key][:arbitraged] > max[:arbitraged] do
      paths[key]
    else
      max  
    end
    _get tail, paths, new_max   
  end
  defp _get([], _paths, max), do: max  

end  
