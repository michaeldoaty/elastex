defmodule ElastexTest do
  use ExUnit.Case
  alias Elastex.Builder


  def req do
    %Builder{
      body: %{greet: "hello world"},
      url: "_search",
      method: :post,
      action: :search_query,
      params: [q: "search"],
      index: "twitter",
      type: "type",
      id: 5,
      headers: [connection: "keep-alive"]
    }
  end


  test "build" do
    expected = Elastex.build(req, %{url: "http://localhost:9200"})

    assert expected == %Builder{
      body: %{greet: "hello world"},
      method: :post,
      url: "http://localhost:9200/_search",
      options: [params: [q: "search"]],
      headers: [accept: "application/json", connection: "keep-alive"],
      action: :search_query
    }
  end


end
