defmodule Arbitrage.Normalise do

  @amount 1000

  def run base, cache do 
    paths = _depth_first(base, cache, cache[:currencies], %{})
    _work_back base, cache, Map.keys(paths), paths
  end

  # Takes you back from final currency to base currency with the exchange rate from final to base
  defp _work_back base, cache, [key | tail], paths do
    # paths[key][:value] This is the amount of money you have in the last currency state
    # cache[paths[key][:path].last][base]) -> Gets the last currency exchange rate back to base
    updated = Map.put(paths[key], :arbitraged,  paths[key][:value] * cache[List.last(paths[key][:path])][base])
    _work_back base, cache, tail, Map.put(paths, key, updated)
  end  
  defp _work_back(_base, _cache, [], paths), do: paths 
   
  defp _depth_first base, cache, [head | tail], paths do
    updated = Map.put paths, "#{base}_#{head}", %{path: [head], value: @amount * cache[base][head]}
    updated = _walk_path(base, "#{base}_#{head}", cache, tail, updated)
    unless Enum.count(Map.keys(updated)) == Enum.count(Map.keys(cache)) - 2 do
      updated = _depth_first base, cache, tail ++ [head], updated
    end   
    updated
  end 
  defp _depth_first(_base, _cache, [], paths), do: paths
  
  defp _walk_path current, key, cache, [head | tail], paths do
    updated = Map.put paths, key, Map.update!(paths[key], :path, &(&1 ++ [head]))
    updated = Map.put updated, key, Map.update!(updated[key], :value, &(&1 * cache[current][head]))
    _walk_path head, key, cache, tail, updated         
  end  
  defp _walk_path(_current, _key, _cache, [], paths), do: paths
end  
