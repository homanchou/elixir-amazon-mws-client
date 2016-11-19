defmodule MWSClient.Utils do

  alias MWSClient.Operation
  # `URI.encode_query/1` explicitly does not percent-encode spaces, but Amazon requires `%20`
  # instead of `+` in the query, so we essentially have to rewrite `URI.encode_query/1` and
  # `URI.pair/1`.
  def percent_encode_query(query_map) do
    Enum.map_join(query_map, "&", &pair/1)
  end

  # See comment on `percent_encode_query/1`.
  defp pair({k, v}) do
    URI.encode(Kernel.to_string(k), &URI.char_unreserved?/1) <>
    "=" <> URI.encode(Kernel.to_string(v), &URI.char_unreserved?/1)
  end

  #takes a map of params, removes a key and with the values of that key,
  #should it be a list, enumerates over each element in the list
  #and puts them back into the map with key of "prefix.appendage.element_index"
  def restructure(params, prefix, appendage) do
    {list, params} = Map.pop(params, prefix)
    Map.merge(params, numbered_params("#{prefix}.#{appendage}", list))
  end

  defp numbered_params(key, nil), do: %{} 
  defp numbered_params(key, list) do
    Enum.with_index(list, 1) 
    |> Enum.reduce(%{}, fn {value, index}, acc -> Map.merge(acc, %{"#{key}.#{index}" => value}) end)
  end
  
  def add(params, options, white_list \\ []) do
    camelized_options = options 
      |> Enum.reject(fn {key, value} -> value == nil || invalid_key?(key, white_list) end)
      |> Enum.map(fn {key, value} -> { Inflex.camelize(key), value} end)
      |> Enum.into(%{})
    Map.merge(params, camelized_options)
  end

  defp invalid_key?(key, []) do
    false 
  end
  defp invalid_key?(key, white_list) do
    Enum.all?(white_list, &(&1 != key))
  end


  def to_operation(params, version, path) do
    %Operation{params: Map.merge(params, %{"Version" => version}), path: path}
  end

end