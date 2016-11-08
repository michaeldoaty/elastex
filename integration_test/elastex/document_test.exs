defmodule Elastex.Integration.DocumentTest do
  use ExUnit.Case

  alias Elastex.Document

  def conn do
    %{url: "http://localhost:9200"}
  end

  def tweet do
    %{"user" => "mike", "message" => "trying out Elasticsearch"}
  end

  def tweet2 do
    %{"user" => "mike", "message" => "still trying out Elasticsearch"}
  end

  def body do
    %{query: %{term: %{user: "mike"}}}
  end


  setup do
    tweet
    |> Elastex.Document.index("twitter", "tweet", 1)
    |> Elastex.run(conn)

    on_exit fn ->
      Elastex.Index.delete("twitter") |> Elastex.run(conn)
    end

    :ok
  end


  test "index" do
    resp = tweet2
    |> Document.index("twitter", "tweet")
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"result" => result}}} = resp
    assert result == "created"
  end


  test "index with id" do
    resp = tweet2
    |> Document.index("twitter", "tweet", 2)
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"_id" => id, "result" => result}}} = resp
    assert result == "created"
    assert id == "2"
  end


  test "get" do
    resp = Document.get("twitter", "tweet", 1) |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"_id" => id, "_source" => source}}} = resp
    assert id == "1"
    assert source == tweet
  end


  test "exists" do
    resp = Document.exists("twitter", "tweet", 1) |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
  end


  test "delete" do
    resp = Document.delete("twitter", "tweet", 1) |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"result" => result}}} = resp
    assert result == "deleted"
  end


  test "update" do
    resp = %{doc: %{message: "updated message"}}
    |> Document.update("twitter", "tweet", 1)
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"result" => result}}} = resp
    assert result == "updated"
  end


  test "mget" do
    # index another message
    tweet2
    |> Document.index("twitter", "tweet", 2)
    |> Elastex.run(conn)

    # call mget
    resp = %{docs: [
      %{_index: "twitter", _type: "tweet", _id: 1},
      %{_index: "twitter", _type: "tweet", _id: 2}
      ]}
    |> Document.mget
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"docs" => docs}}} = resp

    [msg_one, msg_two] = docs |> Enum.map(fn (m) -> m["_source"] end)

    assert msg_one == tweet
    assert msg_two == tweet2
  end


  test "mget with index" do
    # index another message
    tweet2
    |> Document.index("twitter", "tweet", 2)
    |> Elastex.run(conn)

    # call mget
    resp = %{docs: [
      %{_type: "tweet", _id: 1},
      %{_type: "tweet", _id: 2}
      ]}
    |> Document.mget("twitter")
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"docs" => docs}}} = resp

    [msg_one, msg_two] = docs |> Enum.map(fn (m) -> m["_source"] end)

    assert msg_one == tweet
    assert msg_two == tweet2
  end


  test "mget with index and type" do
    # index another message
    tweet2
    |> Document.index("twitter", "tweet", 2)
    |> Elastex.run(conn)

    # call mget
    resp = %{ids: ["1", "2"]}
    |> Document.mget("twitter", "tweet")
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"docs" => docs}}} = resp

    [msg_one, msg_two] = docs |> Enum.map(fn (m) -> m["_source"] end)

    assert msg_one == tweet
    assert msg_two == tweet2
  end


  test "bulk" do
    resp = [
      Elastex.Document.delete("twitter", "tweet", 1),
      Elastex.Document.index(tweet2, "twitter", "tweet", 2)
    ]
    |> Elastex.Document.bulk
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"items" => [delete, index]}}} = resp

    %{"delete" => %{"result" => result_delete}} = delete
    %{"index" => %{"result" => result_index}} = index

    assert result_delete == "deleted"
    assert result_index == "created"
  end


  test "term_vectors" do
    resp = Elastex.Document.term_vectors("twitter", "tweet", 1)
    |> Elastex.Document.params([fields: "message"])
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"term_vectors" => term_vectors}}} = resp

    assert Enum.empty?(term_vectors) == false
  end


  test "term_vectors with body" do
    resp = %{fields: ["text"]}
    |> Elastex.Document.term_vectors("twitter", "tweet", 1)
    |> Elastex.Document.params([fields: "message"])
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"term_vectors" => term_vectors}}} = resp

    assert Enum.empty?(term_vectors) == false
  end


  test "mterm_vectors" do
    # index another message
    tweet2
    |> Document.index("twitter", "tweet", 2)
    |> Elastex.run(conn)

    resp = %{docs: [
      %{_index: "twitter", _type: "tweet", _id: 1, fields: ["message"]},
      %{_index: "twitter", _type: "tweet", _id: 2, fields: ["message"]}
      ]}
      |> Elastex.Document.mterm_vectors
      |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"docs" => docs}}} = resp

    expected = docs
    |> Enum.map(fn (%{"term_vectors" => term_vectors}) ->  term_vectors end)
    |> Enum.any?(&Enum.empty?/1)

    assert expected == false
  end


  test "mterm_vectors with index" do
    # index another message
    tweet2
    |> Document.index("twitter", "tweet", 2)
    |> Elastex.run(conn)

    resp = %{docs: [
      %{_type: "tweet", _id: 1, fields: ["message"]},
      %{_type: "tweet", _id: 2, fields: ["message"]}
      ]}
      |> Elastex.Document.mterm_vectors("twitter")
      |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"docs" => docs}}} = resp

    expected = docs
    |> Enum.map(fn (%{"term_vectors" => term_vectors}) ->  term_vectors end)
    |> Enum.any?(&Enum.empty?/1)

    assert expected == false
  end


  test "mterm_vectors with index and type" do
    # index another message
    tweet2
    |> Document.index("twitter", "tweet", 2)
    |> Elastex.run(conn)

    resp = %{docs: [
      %{_id: 1, fields: ["message"]},
      %{_id: 2, fields: ["message"]}
      ]}
      |> Elastex.Document.mterm_vectors("twitter", "tweet")
      |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"docs" => docs}}} = resp

    expected = docs
    |> Enum.map(fn (%{"term_vectors" => term_vectors}) ->  term_vectors end)
    |> Enum.any?(&Enum.empty?/1)

    assert expected == false
  end


end
