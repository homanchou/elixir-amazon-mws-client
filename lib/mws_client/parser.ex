defmodule MWSClient.Parser do
  
  @moduledoc """
  Get back an enumerator based on the headers
  """

  def parse({:ok, %{body: body, headers: headers, status_code: _status_code}}) do
    case get_content_type(headers) do
      "text/xml" -> XmlToMap.naive_map(body)
      "text/plain;charset="<> charset -> 
        body |> String.split("\r\n") |> CSV.decode(separator: ?\t, headers: true) 
    end
  end

  defp get_content_type(headers) do
    Enum.find_value headers, fn
      {"Content-Type", value} -> value
      _ -> false
    end
  end

end