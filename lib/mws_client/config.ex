defmodule MWSClient.Config do

  @moduledoc """
  Provides a structure for holding required params
  for the api call
  """

  defstruct [
    :aws_access_key_id, 
    :mws_auth_token,
    :seller_id,
    :aws_secret_access_key,
    site_id: "ATVPDKIKX0DER",
    signature_method: "HmacSHA256",
    signature_version: "2",
  ]

  def to_params(struct) do
    %{"AWSAccessKeyId" => struct.aws_access_key_id,
      "MWSAuthToken" => struct.mws_auth_token,
      "SellerId" => struct.seller_id,
      "SignatureMethod" => struct.signature_method,
      "SignatureVersion" => struct.signature_version,
    } 
    |> Enum.into(%{})
  end


end