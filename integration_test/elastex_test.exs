defmodule Elastex.Integration.ElastexTest do
  use ExUnit.Case


  def conn do
    %{url: "http://localhost:9200"}
  end


  test "run from config" do
    resp = Elastex.Search.query()
    |> Elastex.Search.params([q: "user:mike"])
    |> Elastex.run

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
  end


  test "run with conn argument" do
    resp = Elastex.Search.query()
    |> Elastex.Search.params([q: "user:mike"])
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
  end


end
