defmodule Elastex.IndexTest do
  use ExUnit.Case, async: true
  alias Elastex.Index
  alias Elastex.Builder


  doctest Elastex.Index


  def body do
    %{settings: %{number_of_shards: 3, number_of_replicas: 2}}
  end


  test "create" do
    actual = Index.create("twitter")
    expected = %Builder{
      url:    "twitter",
      body:   nil,
      method: :put,
    }
    assert actual == expected
  end


  test "create with body" do
    actual = Index.create(body, "twitter")
    expected = %Builder{
      url:    "twitter",
      body:   body,
      method: :put,
    }
    assert actual == expected
  end


  test "delete" do
    actual = Index.delete("twitter")
    expected = %Builder{
      url:    "twitter",
      method: :delete,
    }
    assert actual == expected
  end


  test "get" do
    actual = Index.get("twitter")
    expected = %Builder{
      url:    "twitter",
      method: :get,
    }
    assert actual == expected
  end


  test "exists" do
    actual = Index.exists("twitter")
    expected = %Builder{
      url:    "twitter",
      method: :head,
    }
    assert actual == expected
  end


  test "close" do
    actual = Index.close("twitter")
    expected = %Builder{
      url:    "twitter/_close",
      method: :post,
    }
    assert actual == expected
  end


  test "open" do
    actual = Index.open("twitter")
    expected = %Builder{
      url:    "twitter/_open",
      method: :post,
    }
    assert actual == expected
  end


  test "shrink" do
    actual = Index.shrink("twitter", "new_twitter")
    expected = %Builder{
      url:    "twitter/_shrink/new_twitter",
      method: :post,
    }
    assert actual == expected
  end


  test "shrink with body" do
    actual = Index.shrink(body, "twitter", "new_twitter")
    expected = %Builder{
      url:    "twitter/_shrink/new_twitter",
      body:   body,
      method: :post,
    }
    assert actual == expected
  end


  test "rollover" do
    actual = Index.rollover(body, "twitter")
    expected = %Builder{
      url:    "twitter/_rollover",
      body:   body,
      method: :post,
    }
    assert actual == expected
  end


  test "rollover with named index" do
    actual = Index.rollover(body, "twitter", "new_twitter")
    expected = %Builder{
      url:    "twitter/_rollover/new_twitter",
      body:   body,
      method: :post,
    }
    assert actual == expected
  end


  test "put_mapping" do
    actual = Index.put_mapping(body, "twitter")
    expected = %Builder{
      url:    "twitter",
      body:   body,
      method: :put,
    }
    assert actual == expected
  end


  test "put_mapping with type" do
    actual = Index.put_mapping(body, "twitter", "tweet")
    expected = %Builder{
      url:    "twitter/_mapping/tweet",
      body:   body,
      method: :put,
    }
    assert actual == expected
  end


  test "get_mapping" do
    actual = Index.get_mapping("twitter")
    expected = %Builder{
      url:    "twitter/_mapping",
      method: :get,
    }
    assert actual == expected
  end


  test "get_mapping with type" do
    actual = Index.get_mapping("twitter", "tweet")
    expected = %Builder{
      url:    "twitter/_mapping/tweet",
      method: :get,
    }
    assert actual == expected
  end


  test "get_field_mapping" do
    actual = Index.get_field_mapping("twitter", "tweet", "message")
    expected = %Builder{
      url:    "twitter/_mapping/tweet/field/message",
      method: :get,
    }
    assert actual == expected
  end


  test "type exists" do
    actual = Index.type_exists("twitter", "tweet")
    expected = %Builder{
      url: "twitter/_mapping/tweet",
      method: :head
    }
    assert actual == expected
  end


  test "aliases" do
    actual = Index.aliases(body)
    expected = %Builder{
      url: "_aliases",
      method: :post,
      body: body
    }
    assert actual == expected
  end


  test "add_alias" do
    actual = Index.add_alias("twitter", "tweet")
    expected = %Builder{
      url: "twitter/_alias/tweet",
      method: :put
    }
    assert actual == expected
  end


  test "add_alias with body" do
    actual = Index.add_alias(body, "twitter", "tweet")
    expected = %Builder{
      url: "twitter/_alias/tweet",
      body: body,
      method: :put
    }
    assert actual == expected
  end


  test "get_alias" do
    actual = Index.get_alias("twitter", "tweet")
    expected = %Builder{
      url: "twitter/_alias/tweet",
      method: :get
    }
    assert actual == expected
  end


  test "delete_alias" do
    actual = Index.delete_alias("twitter", "tweet")
    expected = %Builder{
      url: "twitter/_alias/tweet",
      method: :delete
    }
    assert actual == expected
  end


  test "alias_exists" do
    actual = Index.alias_exists("twitter", "tweet")
    expected = %Builder{
      url: "twitter/_alias/tweet",
      method: :head
    }
    assert actual == expected
  end


  test "update_settings" do
    actual = Index.update_settings(body)
    expected = %Builder{
      url: "_settings",
      body: body,
      method: :put
    }
    assert actual == expected
  end


  test "update_settings with index" do
    actual = Index.update_settings(body, "twitter")
    expected = %Builder{
      url: "twitter/_settings",
      body: body,
      method: :put
    }
    assert actual == expected
  end


  test "get_settings", context do
    actual = Index.get_settings("twitter")
    expected = %Builder{
      url: "twitter/_settings",
      method: :get
    }
    assert actual == expected
  end


  test "analyze" do
    actual = Index.analyze(body)
    expected = %Builder{
      url: "_analyze",
      method: :get,
      body: body
    }
    assert actual == expected
  end


  test "analyze with index" do
    actual = Index.analyze(body, "twitter")
    expected = %Builder{
      url: "twitter/_analyze",
      method: :get,
      body: body
    }
    assert actual == expected
  end


  test "add_template", context do
    actual = Index.add_template(body, "template1")
    expected = %Builder{
      url: "_template/template1",
      method: :put,
      body: body
    }
    assert actual == expected
  end


  test "delete_template" do
    actual = Index.delete_template("template1")
    expected = %Builder{
      url: "_template/template1",
      method: :delete
    }
    assert actual == expected
  end


  test "get_template" do
    actual = Index.get_template("template1")
    expected = %Builder{
      url: "_template/template1",
      method: :get
    }
    assert actual == expected
  end


  test "template_exists" do
    actual = Index.template_exists("template1")
    expected = %Builder{
      url: "_template/template1",
      method: :head
    }
    assert actual == expected
  end


  test "stats" do
    actual = Index.stats()
    expected = %Builder{
      url: "_stats",
      method: :get
    }
    assert actual == expected
  end


  test "stats with index" do
    actual = Index.stats("twitter")
    expected = %Builder{
      url: "twitter/_stats",
      method: :get
    }
    assert actual == expected
  end


  test "segments" do
    actual = Index.segments()
    expected = %Builder{
      url: "_segments",
      method: :get
    }
    assert actual == expected
  end


  test "segments with index" do
    actual = Index.segments("twitter")
    expected = %Builder{
      url: "twitter/_segments",
      method: :get
    }
    assert actual == expected
  end


  test "recovery" do
    actual = Index.recovery()
    expected = %Builder{
      url: "_recovery",
      method: :get
    }
    assert actual == expected
  end


  test "recovery with index" do
    actual = Index.recovery("twitter")
    expected = %Builder{
      url: "twitter/_recovery",
      method: :get
    }
    assert actual == expected
  end


  test "shard_stores" do
    actual = Index.shard_stores()
    expected = %Builder{
      url: "_shard_stores",
      method: :get
    }
    assert actual == expected
  end


  test "shard_stores with index" do
    actual = Index.shard_stores("twitter")
    expected = %Builder{
      url: "twitter/_shard_stores",
      method: :get
    }
    assert actual == expected
  end


  test "clear_cache" do
    actual = Index.clear_cache()
    expected = %Builder{
      url: "_cache/clear",
      method: :post
    }
    assert actual == expected
  end


  test "clear_cache with index" do
    actual = Index.clear_cache("twitter")
    expected = %Builder{
      url: "twitter/_cache/clear",
      method: :post
    }
    assert actual == expected
  end


  test "flush" do
    actual = Index.flush()
    expected = %Builder{
      url: "_flush",
      method: :post
    }
    assert actual == expected
  end


  test "flush with index" do
    actual = Index.flush("twitter")
    expected = %Builder{
      url: "twitter/_flush",
      method: :post
    }
    assert actual == expected
  end


  test "synced_flush" do
    actual = Index.synced_flush()
    expected = %Builder{
      url: "_flush/synced",
      method: :post
    }
    assert actual == expected
  end


  test "synced_flush with index" do
    actual = Index.synced_flush("twitter")
    expected = %Builder{
      url: "twitter/_flush/synced",
      method: :post
    }
    assert actual == expected
  end


  test "refresh" do
    actual = Index.refresh()
    expected = %Builder{
      url: "_refresh",
      method: :post
    }
    assert actual == expected
  end


  test "refresh with index" do
    actual = Index.refresh("twitter")
    expected = %Builder{
      url: "twitter/_refresh",
      method: :post
    }
    assert actual == expected
  end


  test "force_merge" do
    actual = Index.force_merge()
    expected = %Builder{
      url: "_forcemerge",
      method: :post
    }
    assert actual == expected
  end


  test "force_merge with index" do
    actual = Index.force_merge("twitter")
    expected = %Builder{
      url: "twitter/_forcemerge",
      method: :post
    }
    assert actual == expected
  end


  test "params" do
    expected = Index.params(%Builder{}, [q: "search"])
    assert expected == %Builder{
      params: [q: "search"]
    }
  end


  test "params with existing data" do
    expected = Index.params(%Builder{params: [routing: "user"]}, [q: "search"])
    assert expected == %Builder{
      params: [routing: "user", q: "search"]
    }
  end


  test "extend_url" do
    expected = Index.extend_url(%Builder{}, ["twitter"])
    assert expected == %Builder{
      url: "twitter"
    }
  end


  test "extend_url with existing data" do
    expected = Index.extend_url(%Builder{url: "twitter"}, ["tweet"])
    assert expected == %Builder{
      url: "twitter/tweet"
    }
  end


end
