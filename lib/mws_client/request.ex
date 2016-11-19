defmodule MWSClient.Request do
  
  alias MWSClient.Config
  alias MWSClient.Operation

  def to_uri(operation = %Operation{}, config = %Config{}) do
    query = config |> Config.to_params |> Map.merge(operation.params) |> percent_encode_query
    %URI{scheme: "https", host: host(config.site_id), path: operation.path, query: query, port: 443} 
    |> sign_url(config, operation.timestamp, operation.method)
  end

  def host("A2EUQ1WTGCTBG2"), do: "mws.amazonservices.ca"
  def host("AAHKV2X7AFYLW"), do: "mws.amazonservices.com.cn"
  def host("A1PA6795UKMFR9"), do: "mws-eu.amazonservices.com"
  def host("A1RKKUPIHCS9HS"), do: "mws-eu.amazonservices.com"
  def host("A13V1IB3VIYZZH"), do: "mws-eu.amazonservices.com"
  def host("A1F83G8C2ARO7P"), do: "mws-eu.amazonservices.com"
  def host("A21TJRUUN4KGV"), do: "mws.amazonservices.in"
  def host("APJ6JRA9NG5V4"), do: "mws-eu.amazonservices.com"
  def host("A1VC38T7YXB528"), do: "mws.amazonservices.jp"
  def host("A1AM78C64UM0Y8"), do: "mws.amazonservices.com.mx"
  def host("ATVPDKIKX0DER"), do: "mws.amazonservices.com"
 
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

  def sign_url(url_parts, config, timestamp, method) do
    url_parts
    |> add_timestamp(timestamp)
    |> append_signature(config.aws_secret_access_key, method)
  end

  defp add_timestamp(url_parts, timestamp) do
    time = timestamp || DateTime.to_iso8601(DateTime.utc_now)
    updated_query = url_parts.query
      |> URI.decode_query
      |> Map.put_new("Timestamp", time)
      |> percent_encode_query
    Map.put url_parts, :query, updated_query
  end

  defp append_signature(url_parts, aws_secret_access_key, method) do
    hmac = :crypto.hmac(
        :sha256,
        aws_secret_access_key,
        Enum.join([method, url_parts.host, url_parts.path, url_parts.query], "\n")
      )
    signature = Base.encode64(hmac)
    updated_query = url_parts.query <> "&" <> pair({"Signature", signature})
    Map.put url_parts, :query, updated_query
  end


end