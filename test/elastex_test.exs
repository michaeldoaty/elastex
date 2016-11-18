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


  test "run from config" do
    resp = Elastex.Search.query() |> Elastex.run

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
  end


  test "run with conn argument" do
    resp = Elastex.Search.query() |> Elastex.run(%{url: "http://localhost:9200"})

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
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
