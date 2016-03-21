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


  test "bulk_create with map" do
    actual = Document.bulk_create(%{}, body, "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [%{create: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end


  test "bulk_create with id" do
    actual = Document.bulk_create(%{}, body, "twitter", "tweet", 1)
    expected = %{url: "_bulk", method: :post, body: [%{create: %{_index: "twitter", _type: "tweet", _id: 1}}, "\n", body, "\n"]}
    assert actual == expected
  end

  test "bulk_create with existing operations" do
    actual = Document.bulk_create(%{body: [body, "\n"]}, [body], "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [body, "\n", %{create: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end

  test "bulk_create with list" do
    actual = Document.bulk_create(%{}, [body], "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [%{create: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end


  test "bulk_delete without id" do
    actual = Document.bulk_delete(%{}, "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [%{delete: %{_index: "twitter", _type: "tweet"}}, "\n"]}
    assert actual == expected
  end


  test "bulk_delete with id" do
    actual = Document.bulk_delete(%{}, "twitter", "tweet", 1)
    expected = %{url: "_bulk", method: :post, body: [%{delete: %{_index: "twitter", _type: "tweet", _id: 1}}, "\n"]}
    assert actual == expected
  end


  test "bulk_delete with existing operations" do
    actual = Document.bulk_delete(%{body: [body, "\n"]}, "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [body, "\n", %{delete: %{_index: "twitter", _type: "tweet"}}, "\n"]}
    assert actual == expected
  end


  test "bulk_index with map" do
    actual = Document.bulk_index(%{}, body, "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [%{index: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end


  test "bulk_index with id" do
    actual = Document.bulk_index(%{}, body, "twitter", "tweet", 1)
    expected = %{url: "_bulk", method: :post, body: [%{index: %{_index: "twitter", _type: "tweet", _id: 1}}, "\n", body, "\n"]}
    assert actual == expected
  end

  test "bulk_index with existing operations" do
    actual = Document.bulk_index(%{body: [body, "\n"]}, [body], "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [body, "\n", %{index: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end

  test "bulk_index with list" do
    actual = Document.bulk_index(%{}, [body], "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [%{index: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end


  test "bulk_update with map" do
    actual = Document.bulk_update(%{}, body, "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [%{update: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end


  test "bulk_update with id" do
    actual = Document.bulk_update(%{}, body, "twitter", "tweet", 1)
    expected = %{url: "_bulk", method: :post, body: [%{update: %{_index: "twitter", _type: "tweet", _id: 1}}, "\n", body, "\n"]}
    assert actual == expected
  end

  test "bulk_update with existing operations" do
    actual = Document.bulk_update(%{body: [body, "\n"]}, [body], "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [body, "\n", %{update: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end

  test "bulk_update with list" do
    actual = Document.bulk_update(%{}, [body], "twitter", "tweet")
    expected = %{url: "_bulk", method: :post, body: [%{update: %{_index: "twitter", _type: "tweet"}}, "\n", body, "\n"]}
    assert actual == expected
  end

end