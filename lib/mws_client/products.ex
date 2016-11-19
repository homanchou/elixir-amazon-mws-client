defmodule MWSClient.Products do

  @version "2011-10-01"
  @path "/Products/#{@version}"
  @default_market "ATVPDKIKX0DER"

  alias MWSClient.Utils
  alias MWSClient.Operation

  def get_matching_product(asin_list, opts \\ [marketplace_id: @default_market]) do
    
    %{"Action" => "GetMatchingProduct",
      "ASINList" => asin_list}
      |> Utils.add(opts, [:marketplace_id])
      |> Utils.restructure("ASINList", "ASIN")
      |> Utils.to_operation(@version, @path)
  end

  def get_matching_product_for_id(id_type, id_list, opts \\ [marketplace_id: @default_market]) do
    
    %{"Action" => "GetMatchingProductForId",
      "IdType" => id_type, 
      "IdList" => id_list}
      |> Utils.add(opts, [:marketplace_id])
      |> Utils.restructure("IdList", "Id")
      |> Utils.to_operation(@version, @path)
  end

end