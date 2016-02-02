defmodule Elastex.DocumentTest do
  use ExUnit.Case, async: true
  alias Elastex.Document


  def body do
    %{greet: "hello"}
  end


  test "index without id" do
    actual = Document.index(body, "twitter", "tweet")
    expected = %{url: "twitter/tweet", method: :post, body: body}
    assert actual == expected
  end


  test "index with id" do
    actual = Document.index(body, "twitter", "tweet", 1)
    expected = %{url: "twitter/tweet/1", method: :put, body: body}
    assert actual == expected
  end


  test "get" do
    actual = Document.get("twitter", "tweet", 1)
    expected = %{url: "twitter/tweet/1", method: :get}
    assert actual == expected
  end


  test "delete" do
    actual = Document.delete("twitter", "tweet", 1)
    expected = %{url: "twitter/tweet/1", method: :delete}
    assert actual == expected
  end


  test "update_with_script" do
    actual = Document.update_with_script(body, "twitter", "tweet", 1)
    expected = %{url: "twitter/tweet/1/_update", method: :post, body: body}
    assert actual == expected
  end


  test "mget with body" do
    actual = Document.mget(body)
    expected = %{url: "_mget", method: :get, body: body}
    assert actual == expected
  end


  test "mget with index" do
    actual = Document.mget(body, "twitter")
    expected = %{url: "twitter/_mget", method: :get, body: body}
    assert actual == expected
  end

  test "mget with index and type" do
    actual = Document.mget(body, "twitter", "tweet")
    expected = %{url: "twitter/tweet/_mget", method: :get, body: body}
    assert actual == expected
  end


  test "term_vectors" do
    actual = Document.term_vectors("twitter", "tweet", 1)
    expected = %{url: "twitter/tweet/1/_termvectors", method: :get}
    assert actual == expected
  end


  test "mterm_vectors" do
    actual = Document.mterm_vectors(body)
    expected = %{url: "_mtermvectors", method: :get, body: body}
    assert actual == expected
  end


  test "mterm_vectors with index" do
    actual = Document.mterm_vectors(body, "twitter")
    expected = %{url: "twitter/_mtermvectors", method: :get, body: body}
    assert actual == expected
  end


  test "mterm_vectors with index and type" do
    actual = Document.mterm_vectors(body, "twitter", "tweet")
    expected = %{url: "twitter/tweet/_mtermvectors", method: :get, body: body}
    assert actual == expected
  end

end