defmodule Elastex.SearchTest do
  use ExUnit.Case, async: true

  alias Elastex.Search
  alias Elastex.Builder

  doctest Elastex.Search


  def body do
    %{greet: "hello"}
  end


  test "query" do
    actual = Search.query()
    expected = %Builder{
      url: "_search",
      body: nil,
      method: :post,
      action: :search_query
    }
    assert actual == expected
  end


  test "query with body" do
    actual = Search.query(body)
    expected = %Builder{
      url: "_search",
      method: :post,
      body: body,
      action: :search_query,
    }
    assert actual == expected
  end


  test "query with body and index" do
    actual = Search.query(body, "twitter")
    expected = %Builder{
      url: "twitter/_search",
      method: :post,
      body: body,
      action: :search_query,
      index: "twitter"
    }
    assert actual == expected
  end


  test "query with body, index, and type" do
    actual = Search.query(body, "twitter", "tweet")
    expected = %Builder{
      url: "twitter/tweet/_search",
      method: :post,
      body: body,
      action: :search_query,
      index: "twitter",
      type: "tweet"
    }
    assert actual == expected
  end


  test "template" do
    actual = Search.template(body)
    expected = %Builder{
      url: "_search/template",
      method: :post,
      body: body
    }
    assert actual == expected
  end


  test "shards without type" do
    actual = Search.shards("twitter")
    expected = %Builder{
      url: "twitter/_search_shards",
      method: :get,
      index: "twitter",
      type: ""
    }
    assert actual == expected
  end


  test "shards with type" do
    actual = Search.shards("twitter", "tweet")
    expected = %Builder{
      url: "twitter/tweet/_search_shards",
      method: :get,
      index: "twitter",
      type: "tweet"
    }
    assert actual == expected
  end


  test "suggest" do
    actual = Search.suggest(body)
    expected = %Builder{
      url: "_suggest",
      method: :post,
      body: body
    }
    assert actual == expected
  end


  test "multi_search" do
    query_builders = [
      Search.query(body),
      Search.query(body, "twitter", "tweet")
    ]

    actual = Search.multi_search(query_builders)

    expected = %Builder{
      url: "_msearch",
      body: "{}\n{\"greet\":\"hello\"}\n{\"index\":\"twitter\"}\n{\"greet\":\"hello\"}\n",
      action: :multi_search,
      method: :post
    }

    assert actual == expected
  end


  test "count" do
    actual = Search.count()
    expected = %Builder{
      url: "_count",
      body: nil,
      method: :post
    }
    assert actual == expected
  end


  test "count with body" do
    actual = Search.count(body)
    expected = %Builder{
      url: "_count",
      body: body,
      method: :post
    }
    assert actual == expected
  end


  test "count with body and index" do
    actual = Search.count(body, "twitter")
    expected = %Builder{
      url: "twitter/_count",
      body: body,
      method: :post
    }
    assert actual == expected
  end


  test "count with body, index, and type" do
    actual = Search.count(body, "twitter", "tweet")
    expected = %Builder{
      url: "twitter/tweet/_count",
      body: body,
      method: :post
    }
    assert actual == expected
  end


  test "validate" do
    actual = Search.validate()
    expected = %Builder{
      url: "_validate/query",
      method: :post,
      body: nil
    }
    assert actual == expected
  end


  test "validate with body" do
    actual = Search.validate(body)
    expected = %Builder{
      url: "_validate/query",
      method: :post,
      body: body
    }
    assert actual == expected
  end


  test "validate with body and index" do
    actual = Search.validate(body, "twitter")
    expected = %Builder{
      url: "twitter/_validate/query",
      method: :post,
      body: body
    }
    assert actual == expected
  end


  test "validate with body, index, type" do
    actual = Search.validate(body, "twitter", "tweet")
    expected = %Builder{
      url: "twitter/tweet/_validate/query",
      method: :post,
      body: body
    }
    assert actual == expected
  end


  test "explain without body" do
    actual = Search.explain("twitter", "tweet", 1)
    expected = %Builder{
      url: "twitter/tweet/1/_explain",
      method: :post,
      body: nil
    }
    assert actual == expected
  end


  test "explain with body" do
    actual = Search.explain(body, "twitter", "tweet", 1)
    expected = %Builder{
      url: "twitter/tweet/1/_explain",
      method: :post,
      body: body
    }
    assert actual == expected
  end


  test "params" do
    actual = Search.params %Builder{}, [q: "user:kimchy"]
    expected = %Builder{
      params: [q: "user:kimchy"]
    }
    assert actual == expected
  end


  test "params with existing params" do
    params = %Builder{params: [scroll: "1m"]}
    actual = Search.params params, [q: "user:kimchy"]
    expected = %Builder{
      params: [scroll: "1m", q: "user:kimchy"]
    }
    assert actual == expected
  end


  test "params with query" do
    actual = Search.query() |> Search.params([q: "user:kimchy"])
    expected = %Builder{
      url: "_search",
      method: :post,
      action: :search_query,
      params: [q: "user:kimchy"]
    }
    assert actual == expected
  end


  test "query_hits" do
    actual = Search.query_hits({:ok, %HTTPoison.Response{body: %{"hits" => []}}})
    expected = {:ok, []}
    assert actual == expected
  end
end
