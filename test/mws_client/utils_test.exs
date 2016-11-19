defmodule MWSClient.UtilsTest do
  use ExUnit.Case

  alias MWSClient.Utils

  test "percent encodes query" do
    assert Utils.percent_encode_query(%{"term" => "foo bar"}) == "term=foo%20bar"
  end

  test "structure replaces params with numbered params" do
    result = %{"List" => ["term1", "term2"]} |> Utils.restructure("List", "Id")
    assert result == %{"List.Id.1" => "term1", "List.Id.2" => "term2"}
  end

  test "structure works with one item" do
    result = %{"List" => ["term1"]} |> Utils.restructure("List", "Id")
    assert result == %{"List.Id.1" => "term1"}
  end

  test "structure does nothing with zero item" do
    result = %{"List" => nil} |> Utils.restructure("List", "Id")
    assert result == %{}
    result = %{"List" => []} |> Utils.restructure("List", "Id")
    assert result == %{}
  end

  test "add rejects some keys if given whitelist" do
    white_list = [:ok]
    result = %{} |> Utils.add([ok: "yes", not_ok: "no"], white_list)
    assert result == %{"Ok" => "yes"}
  end

end