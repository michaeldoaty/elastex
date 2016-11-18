defmodule Elastex.HelperTest do
  use ExUnit.Case, async: true
  alias Elastex.Helper


  test "path" do
    expected = Helper.path(["twitter", "tweet"])
    assert expected == "twitter/tweet"
  end


end
