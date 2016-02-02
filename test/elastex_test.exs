defmodule ElastexTest do
  use ExUnit.Case


  def body do
    %{greet: "hello"}
  end


  def req do
    %{body: body,
      method: :get,
      params: [q: "user"],
      url: "twitter/tweet",
      headers: [connection: "keep-alive"],
      options: [timeout: 2000]}
  end


  test "custom" do
    actual = Elastex.custom(:get, "twitter/tweet")
    expected = %{url: "twitter/tweet", method: :get, body: ""}
    assert actual == expected
  end


  test "custom with body" do
    actual = Elastex.custom(body, :get, "twitter/tweet")
    expected = %{url: "twitter/tweet", method: :get, body: body}
    assert actual == expected
  end


  test "params" do
    actual = Elastex.params(%{before: true}, [routing: true])
    expected = %{before: true, params: [routing: true]}
    assert actual == expected
  end


  test "headers" do
    actual = Elastex.headers(%{before: true}, [accept: "application/json"])
    expected = %{before: true, headers: [accept: "application/json"]}
    assert actual == expected
  end


  test "http_options" do
    actual = Elastex.http_options(%{before: true}, [timeout: 2000])
    expected = %{before: true, options: [timeout: 2000]}
    assert actual == expected
  end


  test "extend_url" do
    actual = Elastex.extend_url(%{url: "twitter/tweet"}, "_source")
    expected = %{url: "twitter/tweet/_source"}
    assert actual == expected
  end


  test "build - method" do
    actual = Elastex.build(req, %{}).method
    expected = :get
    assert actual == expected
  end


  test "build - joins url" do
    actual = Elastex.build(req, %{url: "http://localhost:9200"}).url
    expected = "http://localhost:9200/twitter/tweet"
    assert actual == expected
  end


  test "build - merges options" do
    actual = Elastex.build(req, %{}).options
    expected = [params: [q: "user"], timeout: 2000]
    assert actual == expected
  end


  test "build - encodes body" do
    actual = Elastex.build(req, %{}).body
    expected = "{\"greet\":\"hello\"}"
    assert actual == expected
  end


  test "build - merges headers" do
    actual = Elastex.build(req, %{}).headers
    expected = [accept: "application/json", connection: "keep-alive"]
    assert actual == expected
  end

end
