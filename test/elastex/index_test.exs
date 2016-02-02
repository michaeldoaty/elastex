defmodule Elastex.IndexTest do
  use ExUnit.Case, async: true
  alias Elastex.Index

  def body do
    %{greet: "hello"}
  end

  test "create" do
    actual = Index.create("twitter")
    expected = %{url: "twitter", method: :put, body: ""}
    assert actual == expected
  end

  test "create with body" do
    actual = Index.create(body, "twitter")
    expected = %{url: "twitter", method: :put, body: body}
    assert actual == expected
  end


  test "delete" do
    actual = Index.delete("twitter")
    expected = %{url: "twitter", method: :delete}
    assert actual == expected
  end


  test "get" do
    actual = Index.get("twitter")
    expected = %{url: "twitter", method: :get}
    assert actual == expected
  end


  test "exists" do
    actual = Index.exists("twitter")
    expected = %{url: "twitter", method: :head}
    assert actual == expected
  end


  test "close" do
    actual = Index.close("twitter")
    expected = %{url: "twitter/_close", method: :post}
    assert actual == expected
  end


  test "open" do
    actual = Index.open("twitter")
    expected = %{url: "twitter/_open", method: :post}
    assert actual == expected
  end


  test "put_mapping without a type" do
    actual = Index.put_mapping(body, "twitter")
    expected = %{url: "twitter", method: :put, body: body}
    assert actual == expected
  end


  test "put_mapping with type" do
    actual = Index.put_mapping(body, "twitter", "tweet")
    expected = %{url: "twitter/_mapping/tweet", method: :put, body: body}
    assert actual == expected
  end


  test "get_mapping without type" do
    actual = Index.get_mapping("twitter")
    expected = %{url: "twitter/_mapping", method: :get}
    assert actual == expected
  end


  test "get_mapping with type" do
    actual = Index.get_mapping("twitter", "tweet")
    expected = %{url: "twitter/_mapping/tweet", method: :get}
    assert actual == expected
  end


  test "type exists" do
    actual = Index.type_exists("twitter", "tweet")
    expected = %{url: "twitter/tweet", method: :head}
    assert actual == expected
  end


  test "aliases" do
    actual = Index.aliases(body)
    expected = %{url: "_aliases", method: :post, body: body}
    assert actual == expected
  end


  test "add_alias" do
    actual = Index.add_alias("twitter", "tweet")
    expected = %{url: "twitter/_alias/tweet", method: :put}
    assert actual == expected
  end


  test "get_alias" do
    actual = Index.get_alias("twitter", "tweet")
    expected = %{url: "twitter/_alias/tweet", method: :get}
    assert actual == expected
  end


  test "delete_alias" do
    actual = Index.delete_alias("twitter", "tweet")
    expected = %{url: "twitter/_alias/tweet", method: :delete}
    assert actual == expected
  end


  test "update_settings" do
    actual = Index.update_settings(body, "twitter")
    expected = %{url: "twitter/_settings", method: :put, body: body}
    assert actual == expected
  end


  test "get_settings", context do
    actual = Index.get_settings("twitter")
    expected = %{url: "twitter/_settings", method: :get}
    assert actual == expected
  end


  test "analyze without index" do
    actual = Index.analyze(body)
    expected = %{url: "_analyze", method: :get, body: body}
    assert actual == expected
  end


  test "analyze with index" do
    actual = Index.analyze(body, "twitter")
    expected = %{url: "twitter/_analyze", method: :get, body: body}
    assert actual == expected
  end


  test "add_template", context do
    actual = Index.add_template(body, "template1")
    expected = %{url: "_template/template1", method: :put, body: body}
    assert actual == expected
  end


  test "delete_template" do
    actual = Index.delete_template("template1")
    expected = %{url: "_template/template1", method: :delete}
    assert actual == expected
  end


  test "get_template" do
    actual = Index.get_template("template1")
    expected = %{url: "_template/template1", method: :get}
    assert actual == expected
  end


  test "template_exists" do
    actual = Index.template_exists("template1")
    expected = %{url: "_template/template1", method: :head}
    assert actual == expected
  end


  test "put_warmer with body and warmer" do
    actual = Index.put_warmer(body, "warmer_name")
    expected = %{url: "_warmer/warmer_name", method: :put, body: body}
    assert actual == expected
  end


  test "put_warmer with index" do
    actual = Index.put_warmer(body, "twitter", "warmer_name")
    expected = %{url: "twitter/_warmer/warmer_name", method: :put, body: body}
    assert actual == expected
  end


  test "put_warmer with index and type" do
    actual = Index.put_warmer(body, "twitter", "tweet", "warmer_name")
    expected = %{url: "twitter/tweet/_warmer/warmer_name", method: :put, body: body}
    assert actual == expected
  end


  test "delete_warmer" do
    actual = Index.delete_warmer("twitter", "warmer_name")
    expected = %{url: "twitter/_warmer/warmer_name", method: :delete}
    assert actual == expected
  end


  test "get_warmer without warmer" do
    actual = Index.get_warmer("twitter")
    expected = %{url: "twitter/_warmer", method: :get}
    assert actual == expected
  end


  test "get_warmer with index and warmer" do
    actual = Index.get_warmer("twitter", "warmer_name")
    expected = %{url: "twitter/_warmer/warmer_name", method: :get}
    assert actual == expected
  end


  test "stats" do
    actual = Index.stats()
    expected = %{url: "_stats", method: :get}
    assert actual == expected
  end


  test "stats with index" do
    actual = Index.stats("twitter")
    expected = %{url: "twitter/_stats", method: :get}
    assert actual == expected
  end


  test "segments without index" do
    actual = Index.segments()
    expected = %{url: "_segments", method: :get}
    assert actual == expected
  end


  test "segments with index" do
    actual = Index.segments("twitter")
    expected = %{url: "twitter/_segments", method: :get}
    assert actual == expected
  end


  test "recovery" do
    actual = Index.recovery()
    expected = %{url: "_recovery", method: :get}
    assert actual == expected
  end


  test "recovery with index" do
    actual = Index.recovery("twitter")
    expected = %{url: "twitter/_recovery", method: :get}
    assert actual == expected
  end


  test "shard_stores" do
    actual = Index.shard_stores()
    expected = %{url: "_shard_stores", method: :get}
    assert actual == expected
  end


  test "shard_stores with index" do
    actual = Index.shard_stores("twitter")
    expected = %{url: "twitter/_shard_stores", method: :get}
    assert actual == expected
  end


  test "clear_cache" do
    actual = Index.clear_cache()
    expected = %{url: "_cache/clear", method: :post}
    assert actual == expected
  end

  test "clear_cache with index" do
    actual = Index.clear_cache("twitter")
    expected = %{url: "twitter/_cache/clear", method: :post}
    assert actual == expected
  end


  test "flush" do
    actual = Index.flush()
    expected = %{url: "_flush", method: :post}
    assert actual == expected
  end


  test "flush with index" do
    actual = Index.flush("twitter")
    expected = %{url: "twitter/_flush", method: :post}
    assert actual == expected
  end


  test "synced_flush" do
    actual = Index.synced_flush()
    expected = %{url: "_flush/synced", method: :post}
    assert actual == expected
  end


  test "synced_flush with index" do
    actual = Index.synced_flush("twitter")
    expected = %{url: "twitter/_flush/synced", method: :post}
    assert actual == expected
  end


  test "refresh" do
    actual = Index.refresh()
    expected = %{url: "_refresh", method: :post}
    assert actual == expected
  end


  test "refresh with index" do
    actual = Index.refresh("twitter")
    expected = %{url: "twitter/_refresh", method: :post}
    assert actual == expected
  end


  test "force_merge" do
    actual = Index.force_merge()
    expected = %{url: "_forcemerge", method: :post}
    assert actual == expected
  end


  test "force_merge with index" do
    actual = Index.force_merge("twitter")
    expected = %{url: "twitter/_forcemerge", method: :post}
    assert actual == expected
  end


  test "upgrade" do
    actual = Index.upgrade()
    expected = %{url: "_upgrade", method: :post}
    assert actual == expected
  end


  test "upgrade with index" do
    actual = Index.upgrade("twitter")
    expected = %{url: "twitter/_upgrade", method: :post}
    assert actual == expected
  end

end