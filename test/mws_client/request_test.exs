defmodule MWSClient.RequestTest do

  use ExUnit.Case

  alias MWSClient.Config
  alias MWSClient.Request
  alias MWSClient.Products

  setup do
    operation = Products.get_matching_product_for_id("ASIN", ["B00KO1C94A"]) |>
      Map.merge(%{timestamp: "2016-10-24T21:29:06Z"})
    
    config = %Config{
      seller_id: "SELLERID",
      mws_auth_token: "amzn.mws.some-jumble-of-characters",
      site_id: "ATVPDKIKX0DER",
      aws_access_key_id: "SOMEACCESSID",
      aws_secret_access_key: "ASecretCodeIdYesItVeryLongButYeah",
    }

    {:ok, config: config, operation: operation}
  end

  test "signs signature", %{config: config, operation: operation} do    
    result = operation |> MWSClient.Request.to_uri(config)
    assert result.query == "AWSAccessKeyId=SOMEACCESSID&Action=GetMatchingProductForId&IdList.Id.1=B00KO1C94A&IdType=ASIN&MWSAuthToken=amzn.mws.some-jumble-of-characters&MarketplaceId=ATVPDKIKX0DER&SellerId=SELLERID&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2016-10-24T21%3A29%3A06Z&Version=2011-10-01&Signature=eGVWyR8F8DIcUGtPbnVG5KXriNPSLXjqs%2B780mqA0AY%3D"
  end


  test "sorts params lexicographically" do
    params = %{"A10" => 1, "A1" => 2}
    assert "A1=2&A10=1" == Request.percent_encode_query(params)
  end

  test "it encodes spaces with %20" do
    params = %{"Title" => "This is my title"}
    assert "Title=This%20is%20my%20title" == Request.percent_encode_query(params)
  end

  test "it does not escape tilde" do
    params = %{"Title" => "~,"}
    assert "Title=~%2C" == Request.percent_encode_query(params)
  end

  @doc """
  Taken from the Example REST Requests page of the Product Advertising API documentation:
  http://docs.aws.amazon.com/AWSECommerceService/latest/DG/rest-signature.html
  """
  test "adds Signature at the end" do
    config = %Config{aws_secret_access_key: "1234567890"}
    unsigned =
      "http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&" <>
      "Operation=ItemLookup&ItemId=0679722769&ResponseGroup=ItemAttributes,Offers,Images,Reviews&Version=" <>
      "2009-01-06&Timestamp=2009-01-01T12:00:00Z"
    signed =
      "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&ItemId=0679722769&Operation=" <>
      "ItemLookup&ResponseGroup=ItemAttributes%2COffers%2CImages%2CReviews&Service=AWSECommerceService" <> 
      "&Timestamp=2009-01-01T12%3A00%3A00Z&Version=2009-01-06&Signature=" <>
      "M%2Fy0%2BEAFFGaUAp4bWv%2FWEuXYah99pVsxvqtAuC8YN7I%3D"
    assert signed == Request.sign_url(URI.parse(unsigned), config, "2009-01-01T12:00:00Z", "GET") |> to_string
  end

end
