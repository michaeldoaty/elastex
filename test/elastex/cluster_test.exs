defmodule Elastex.ClusterTest do
  use ExUnit.Case, async: true
  alias Elastex.Cluster


  def body do
    %{greet: "hello"}
  end


  test "health without index" do
    actual = Cluster.health()
    expected = %{url: "_cluster/health", method: :get}
    assert actual == expected
  end


  test "health with index" do
    actual = Cluster.health("twitter")
    expected = %{url: "_cluster/health/twitter", method: :get}
    assert actual == expected
  end


  test "state with no arguments" do
    actual = Cluster.state()
    expected = %{url: "_cluster/state", method: :get}
    assert actual == expected
  end


  test "state with metrics and index" do
    actual = Cluster.state("twitter", "metadata")
    expected = %{url: "_cluster/state/metadata/twitter", method: :get}
    assert actual == expected
  end


  test "stats" do
    actual = Cluster.stats()
    expected = %{url: "_cluster/stats", method: :get}
    assert actual == expected
  end


  test "pending_tasks" do
    actual = Cluster.pending_tasks()
    expected = %{url: "_cluster/pending_tasks", method: :get}
    assert actual == expected
  end


  test "reroute" do
    actual = Cluster.reroute(body)
    expected = %{url: "_cluster/reroute", method: :post, body: body}
    assert actual == expected
  end


  test "node_stats" do
    actual = Cluster.node_stats()
    expected = %{url: "_nodes/stats", method: :get}
    assert actual == expected
  end


  test "node_stats with stats" do
    actual = Cluster.node_stats("os,process")
    expected = %{url: "_nodes/stats/os,process", method: :get}
    assert actual == expected
  end


  test "node_stats with stats and nodes" do
    actual = Cluster.node_stats("os,process", "nodeId1")
    expected = %{url: "_nodes/nodeId1/stats/os,process", method: :get}
    assert actual == expected
  end


  test "node_info" do
    actual = Cluster.node_info()
    expected = %{url: "_nodes", method: :get}
    assert actual == expected
  end


  test "node_info with attributes" do
    actual = Cluster.node_info("jvm,process")
    expected = %{url: "_nodes/jvm,process", method: :get}
    assert actual == expected
  end


  test "node_info with attributes and nodes" do
    actual = Cluster.node_info("jvm,process", "nodeId1")
    expected = %{url: "_nodes/nodeId1/jvm,process", method: :get}
    assert actual == expected
  end


  test "node_hot_threads" do
    actual = Cluster.node_hot_threads("nodeId1")
    expected = %{url: "_nodes/nodeId1/hot_threads", method: :get}
    assert actual == expected
  end

end