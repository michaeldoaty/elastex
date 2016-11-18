defmodule Elastex.Integration.SearchTest do
  use ExUnit.Case

  alias Elastex.Search

  def conn do
    %{url: "http://localhost:9200"}
  end

  def tweet do
    %{"user" => "mike", "message" => "trying out Elasticsearch"}
  end

  def body do
    %{query: %{term: %{user: "mike"}}}
  end


  setup do
    tweet
    |> Elastex.Document.index("twitter", "tweet", 1)
    |> Elastex.run(conn)

    on_exit fn ->
      Elastex.Document.delete("twitter", "tweet", 1) |> Elastex.run(conn)
    end

    :ok
  end


  test "query" do
    hits = Search.query()
    |> Elastex.Search.params([q: "user:mike"])
    |> Elastex.run(conn)
    |> Elastex.Search.query_hits

    {:ok, %{"hits" => [%{"_source" => source}]}} = hits
    assert source == tweet
  end


  test "query with body" do
    hits = Search.query(body)
    |> Elastex.run(conn)
    |> Elastex.Search.query_hits

    {:ok, %{"hits" => [%{"_source" => source}]}} = hits
    assert source == tweet
  end


  test "query with body and index" do
    hits = Search.query(body, "twitter")
    |> Elastex.run(conn)
    |> Elastex.Search.query_hits

    {:ok, %{"hits" => [%{"_source" => source}]}} = hits
    assert source == tweet
  end


  test "query with body, index, and type" do
    hits = Search.query(body, "twitter", "tweet")
    |> Elastex.run(conn)
    |> Elastex.Search.query_hits

    {:ok, %{"hits" => [%{"_source" => source}]}} = hits
    assert source == tweet
  end


  test "template" do
    hits = Search.template(%{
      inline: %{query: %{match: %{user: "{{query_string}}"}}},
      params: %{query_string: "mike"}})
    |> Elastex.run(conn)
    |> Elastex.Search.query_hits

    {:ok, %{"hits" => [%{"_source" => source}]}} = hits
    assert source == tweet
  end


  test "shards without type" do
    resp = Search.shards("twitter") |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: body}} = resp

    assert Map.has_key?(body, "nodes") == true
  end


  test "shards with type" do
    resp = Search.shards("twitter", "tweet") |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: body}} = resp

    assert Map.has_key?(body, "nodes") == true
  end


  test "suggest" do
    resp = Search.suggest(%{
      "my-suggestion" => %{
        text: "search",
        term: %{field: "message"}
      }
    })
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"my-suggestion" => [%{"length" => length}]}}} = resp
    assert length > 0
  end


  test "multi_search" do
    resp = [
      Search.query(body),
      Search.query(body, "twitter", "tweet")
    ]
    |> Elastex.Search.multi_search
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"responses" => responses}}} = resp
    sources = Enum.map responses, fn (%{"hits" => %{"hits" => [%{"_source"=> source}]}}) -> source end

    assert sources == [tweet, tweet]
  end


  test "count" do
    resp = Elastex.Search.count
    |> Elastex.Search.params([q: "user:mike"])
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"count" => count}}} = resp
    assert count == 1
  end


  test "count with body" do
    resp = Elastex.Search.count(body)
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"count" => count}}} = resp
    assert count == 1
  end


  test "count with body and index" do
    resp = Elastex.Search.count(body, "twitter")
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"count" => count}}} = resp
    assert count == 1
  end


  test "count with body, index and type" do
    resp = Elastex.Search.count(body, "twitter", "tweet")
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"count" => count}}} = resp
    assert count == 1
  end


  test "validate" do
    resp = Elastex.Search.validate
    |> Elastex.Search.params([q: "user:mike"])
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"valid" => valid}}} = resp
    assert valid == true
  end


  test "validate with body" do
    resp = Elastex.Search.validate(body)
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"valid" => valid}}} = resp
    assert valid == true
  end


  test "validate with body and index" do
    resp = Elastex.Search.validate(body, "twitter")
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"valid" => valid}}} = resp
    assert valid == true
  end


  test "validate with body, index, and type" do
    resp = Elastex.Search.validate(body, "twitter", "tweet")
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"valid" => valid}}} = resp
    assert valid == true
  end


  test "explain without body" do
    resp = Search.explain("twitter", "tweet", 1)
    |> Elastex.Search.params([q: "user:mike"])
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
  end


  test "explain" do
    resp = Search.explain(body, "twitter", "tweet", 1)
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
  end
end
