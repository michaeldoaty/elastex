defmodule Elastex.DocumentTest do
  use ExUnit.Case, async: true
  alias Elastex.Document
  alias Elastex.Builder

  doctest Elastex.Document


  def body do
    %{greet: "hello"}
  end


  test "index" do
    actual = Document.index(body, "twitter", "tweet")
    expected = %Builder{
      url:    "twitter/tweet",
      body:   body,
      method: :post,
      action: :document_index,
      index:  "twitter",
      type:   "tweet"
    }
    assert actual == expected
  end


  test "index with id" do
    actual = Document.index(body, "twitter", "tweet", 1)
    expected = %Builder{
      url:    "twitter/tweet/1",
      body:   body,
      method: :put,
      action: :document_index,
      index:  "twitter",
      type:   "tweet",
      id:     1
    }
    assert actual == expected
  end


  test "get" do
    actual = Document.get("twitter", "tweet", 1)
    expected = %Builder{url: "twitter/tweet/1", method: :get, body: nil}
    assert actual == expected
  end


  test "delete" do
    actual = Document.delete("twitter", "tweet", 1)
    expected = %Builder{
      url:    "twitter/tweet/1",
      body:   nil,
      method: :delete,
      action: :document_delete,
      index:  "twitter",
      type:   "tweet",
      id:     1
    }
    assert actual == expected
  end


  test "update" do
    actual = Document.update(body, "twitter", "tweet", 1)
    expected = %Builder{
      url:    "twitter/tweet/1/_update",
      body:   body,
      method: :post,
      action: :document_update,
      index:  "twitter",
      type:   "tweet",
      id:     1
    }
    assert actual == expected
  end


  test "mget" do
    actual = Document.mget(body)
    expected = %Builder{url: "_mget", method: :get, body: body}
    assert actual == expected
  end


  test "mget with index" do
    actual = Document.mget(body, "twitter")
    expected = %Builder{url: "twitter/_mget", method: :get, body: body}
    assert actual == expected
  end

  test "mget with index and type" do
    actual = Document.mget(body, "twitter", "tweet")
    expected = %Builder{url: "twitter/tweet/_mget", method: :get, body: body}
    assert actual == expected
  end


  test "term_vectors without body" do
    actual = Document.term_vectors("twitter", "tweet", 1)
    expected = %Builder{url: "twitter/tweet/1/_termvectors", method: :get}
    assert actual == expected
  end


  test "term_vectors with body" do
    actual = Document.term_vectors(body, "twitter", "tweet", 1)
    expected = %Builder{url: "twitter/tweet/1/_termvectors", method: :get, body: body}
    assert actual == expected
  end


  test "mterm_vectors" do
    actual = Document.mterm_vectors(body)
    expected = %Builder{url: "_mtermvectors", method: :get, body: body}
    assert actual == expected
  end


  test "mterm_vectors with index" do
    actual = Document.mterm_vectors(body, "twitter")
    expected = %Builder{url: "twitter/_mtermvectors", method: :get, body: body}
    assert actual == expected
  end


  test "mterm_vectors with index and type" do
    actual = Document.mterm_vectors(body, "twitter", "tweet")
    expected = %Builder{url: "twitter/tweet/_mtermvectors", method: :get, body: body}
    assert actual == expected
  end

  test "bulk" do
    bulk_commands = [
      Document.delete("twitter", "tweet", 1),
      Document.index(body, "twitter", "tweet")
    ]

    actual = Document.bulk(bulk_commands)

    expected = %Builder{
      url: "_bulk",
      method: :post,
      action: :document_bulk,
      body: "{\"delete\":{\"_type\":\"tweet\",\"_index\":\"twitter\",\"_id\":1}}\n{\"index\":{\"_type\":\"tweet\",\"_index\":\"twitter\"}}\n{\"greet\":\"hello\"}\n"
    }

    assert actual == expected
  end

  test "bulk with incorrect bulk argument" do
    bulk_commands = [
      Document.exists("twitter", "tweet", 1),
      Document.index(body, "twitter", "tweet")
    ]
    
    actual = Document.bulk(bulk_commands)
    expected = %RuntimeError{message: "Request must be from Elastex.Document.delete, Elastex.Document.index, or Elastex.Document.create"}
    assert actual == expected
  end

end
