defmodule Elastex.HelperTest do
  use ExUnit.Case, async: true
  alias Elastex.Helper


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


  test "get_body - ok response" do
    actual = Helper.get_body({:ok, %{body: {:ok, body}}})
    expected = body
    assert actual == expected
  end


  test "get_body - error response top level" do
    actual = Helper.get_body({:error, %{body: {:ok, body}}})
    expected = nil
    assert actual == expected
  end


  test "get_body - error response at body" do
    actual = Helper.get_body({:ok, %{body: {:error, body}}})
    expected = nil
    assert actual == expected
  end


  test "get_body - missing body" do
    actual = Helper.get_body({:ok, %{headers: []}})
    expected = nil
    assert actual == expected
  end


  test "build - method" do
    actual = Helper.build(req, %{}).method
    expected = :get
    assert actual == expected
  end


  test "build - joins url" do
    actual = Helper.build(req, %{url: "http://localhost:9200"}).url
    expected = "http://localhost:9200/twitter/tweet"
    assert actual == expected
  end


  test "build - merges options" do
    actual = Helper.build(req, %{}).options
    expected = [params: [q: "user"], timeout: 2000]
    assert actual == expected
  end


  test "build - body" do
    actual = Helper.build(req, %{}).body
    expected = body
    assert actual == expected
  end


  test "build - merges headers" do
    actual = Helper.build(req, %{}).headers
    expected = [accept: "application/json", connection: "keep-alive"]
    assert actual == expected
  end

end
