defmodule MWSClient do

  use HTTPoison.Base

  alias MWSClient.Config
  alias MWSClient.Operation
  alias MWSClient.Request

  def request(operation = %Operation{}, config = %Config{}) do
    uri = Request.to_uri(operation, config)
    
    response = post uri, uri.query
    
  end






end
