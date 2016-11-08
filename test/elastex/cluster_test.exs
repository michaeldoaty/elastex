defmodule Elastex.ClusterTest do
  use ExUnit.Case, async: true
  alias Elastex.Cluster
  alias Elastex.Builder


  doctest Elastex.Builder


  def body do
    %{greet: "hello"}
  end


  test "health without index" do
    actual = Cluster.health()
    expected = %Builder{
      url: "_cluster/health",
      method: :get
    }
    assert actual == expected
  end


  test "health with index" do
    actual = Cluster.health("twitter")
    expected = %Builder{
      url: "_cluster/health/twitter",
      method: :get
    }
    assert actual == expected
  end


  test "state" do
    actual = Cluster.state()
    expected = %Builder{
      url: "_cluster/state",
      method: :get
    }
    assert actual == expected
  end


  test "state with metrics" do
    actual = Cluster.state("metadata")
    expected = %Builder{
      url: "_cluster/state/metadata",
      method: :get
    }
    assert actual == expected
  end


  test "state with metrics and index" do
    actual = Cluster.state("metadata", "twitter")
    expected = %Builder{
      url: "_cluster/state/metadata/twitter",
      method: :get
    }
    assert actual == expected
  end


  test "stats" do
    actual = Cluster.stats()
    expected = %Builder{
      url: "_cluster/stats",
      method: :get
    }
    assert actual == expected
  end


  test "pending_tasks" do
    actual = Cluster.pending_tasks()
    expected = %Builder{
      url: "_cluster/pending_tasks",
      method: :get
    }
    assert actual == expected
  end


  test "reroute" do
    actual = Cluster.reroute(body)
    expected = %Builder{
      url: "_cluster/reroute",
      method: :post,
      body: body
    }
    assert actual == expected
  end


  test "update_settings" do
    actual = Cluster.update_settings(body)
    expected = %Builder{
      url: "_cluster/settings",
      method: :put,
      body: body
    }
    assert actual == expected
  end


  test "get_settings" do
    actual = Cluster.get_settings()
    expected = %Builder{
      url: "_cluster/settings",
      method: :get
    }
    assert actual == expected
  end


  test "node_stats" do
    actual = Cluster.node_stats()
    expected = %Builder{
      url: "_nodes/stats",
      method: :get
    }
    assert actual == expected
  end


  test "node_stats with nodes" do
    actual = Cluster.node_stats("nodeId1,nodeId2")
    expected = %Builder{
      url: "_nodes/nodeId1,nodeId2/stats",
      method: :get
    }
    assert actual == expected
  end


  test "node_stats with nodes and stats" do
    actual = Cluster.node_stats("nodeId1,nodeId2", "process")
    expected = %Builder{
      url: "_nodes/nodeId1,nodeId2/stats/process",
      method: :get
    }
    assert actual == expected
  end


  test "node_info" do
    actual = Cluster.node_info()
    expected = %Builder{
      url: "_nodes",
      method: :get
    }
    assert actual == expected
  end


  test "node_info with nodes" do
    actual = Cluster.node_info("jvm,process")
    expected = %Builder{
      url: "_nodes/jvm,process",
      method: :get
    }
    assert actual == expected
  end


  test "node_info with nodes and info" do
    actual = Cluster.node_info("nodeId1", "jvm,process")
    expected = %Builder{
      url: "_nodes/nodeId1/jvm,process",
      method: :get
    }
    assert actual == expected
  end


  test "node_hot_threads" do
    actual = Cluster.node_hot_threads()
    expected = %Builder{
      url: "_nodes/hot_threads",
      method: :get
    }
    assert actual == expected
  end


  test "node_hot_threads with threads" do
    actual = Cluster.node_hot_threads("nodeId1")
    expected = %Builder{
      url: "_nodes/nodeId1/hot_threads",
      method: :get
    }
    assert actual == expected
  end

end
