defmodule Elastex.ExtenderTest do
  use ExUnit.Case, async: true
  alias Elastex.Extender
  alias Elastex.Builder


  test "params" do
    expected = Extender.params(%Builder{}, [q: "search"])
    assert expected == %Builder{
      params: [q: "search"]
    }
  end


  test "params with existing data" do
    expected = Extender.params(%Builder{params: [routing: "user"]}, [q: "search"])
    assert expected == %Builder{
      params: [routing: "user", q: "search"]
    }
  end


  test "extend_url" do
    expected = Extender.extend_url(%Builder{}, ["twitter"])
    assert expected == %Builder{
      url: "twitter"
    }
  end


  test "extend_url with existing data" do
    expected = Extender.extend_url(%Builder{url: "twitter"}, ["tweet"])
    assert expected == %Builder{
      url: "twitter/tweet"
    }
  end


end
