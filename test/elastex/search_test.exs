defmodule Elastex.SearchTest do
  use ExUnit.Case, async: true
  alias Elastex.Search


  def body do
    %{greet: "hello"}
  end


  test "query" do
    actual = Search.query()
    expected = %{url: "_search", method: :get, body: ""}
    assert actual == expected
  end


  test "query with body" do
    actual = Search.query(body)
    expected = %{url: "_search", method: :get, body: body}
    assert actual == expected
  end


  test "query with body and index" do
    actual = Search.query(body, "twitter")
    expected = %{url: "twitter/_search", method: :get, body: body}
    assert actual == expected
  end


  test "query with body, index, and type" do
    actual = Search.query(body, "twitter", "tweet")
    expected = %{url: "twitter/tweet/_search", method: :get, body: body}
    assert actual == expected
  end


  test "template" do
    actual = Search.template(body)
    expected = %{url: "template", method: :get, body: body}
    assert actual == expected
  end


  test "shards without type" do
    actual = Search.shards("twitter")
    expected = %{url: "twitter/_search_shards", method: :get}
    assert actual == expected
  end


  test "shards with type" do
    actual = Search.shards("twitter", "tweet")
    expected = %{url: "twitter/tweet/_search_shards", method: :get}
    assert actual == expected
  end


  test "suggest" do
    actual = Search.suggest(body)
    expected = %{url: "_suggest", method: :get, body: body}
    assert actual == expected
  end


  test "count without body" do
    actual = Search.count("twitter", "tweet")
    expected = %{url: "twitter/tweet/_count", method: :get, body: ""}
    assert actual == expected
  end


  test "count with body" do
    actual = Search.count(body, "twitter", "tweet")
    expected = %{url: "twitter/tweet/_count", method: :get, body: body}
    assert actual == expected
  end


  test "validate" do
    actual = Search.validate(body)
    expected = %{url: "_validate/query", method: :get, body: body}
    assert actual == expected
  end


  test "validate with index" do
    actual = Search.validate(body, "twitter")
    expected = %{url: "twitter/_validate/query", method: :get, body: body}
    assert actual == expected
  end


  test "validate with index and type" do
    actual = Search.validate(body, "twitter", "tweet")
    expected = %{url: "twitter/tweet/_validate/query", method: :get, body: body}
    assert actual == expected
  end


  test "explain" do
    actual = Search.explain(body, "twitter", "tweet", 1)
    expected = %{url: "twitter/tweet/1/_explain", method: :get, body: body}
    assert actual == expected
  end

end