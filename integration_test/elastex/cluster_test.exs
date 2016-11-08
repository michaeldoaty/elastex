defmodule Elastex.Integration.ClusterTest do
  use ExUnit.Case

  alias Elastex.Cluster


  def tweet do
    %{"user" => "mike", "message" => "trying out Elasticsearch"}
  end


  def conn do
    %{url: "http://localhost:9200"}
    end


  setup context do
    tweet
    |> Elastex.Document.index("twitter", "tweet", 1)
    |> Elastex.run(conn)

    node_info = Cluster.node_info |> Elastex.run(conn)
    {:ok, %HTTPoison.Response{body: %{"nodes" => nodes}}} = node_info

    [node | _] = Map.keys(nodes)

    on_exit fn ->
      Elastex.Index.delete("twitter")
    end

    {:ok, Dict.put(context, :node, node)}
  end


  test "health" do
    resp = Cluster.health |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"status" => status}}} = resp
    assert status == "yellow"
  end


  test "health with index" do
    resp = Cluster.health("twitter") |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"status" => status}}} = resp
    assert status == "yellow"
  end


  test "state" do
    resp = Cluster.state |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"cluster_name" => cluster_name}}} = resp
    assert cluster_name == "elasticsearch"
  end


  test "state with metrics" do
    resp = Cluster.state("cluster_name") |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"cluster_name" => cluster_name}}} = resp
    assert cluster_name == "elasticsearch"
  end


  test "state with metrics and index" do
    resp = Cluster.state("cluster_name", "twitter") |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"cluster_name" => cluster_name}}} = resp
    assert cluster_name == "elasticsearch"
  end


  test "stats" do
    resp = Cluster.stats |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"_nodes" => _nodes}, status_code: status_code}} = resp
    assert status_code == 200
  end


  test "pending_tasks" do
    resp = Cluster.pending_tasks |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"tasks" => tasks}}} = resp
    assert tasks == []
  end


  # TODO:MD Setup up multi node system
  # test "reroute", context do
  #   resp = %{commands: [%{move: %{index: "test", shard: 0,
  #                                 from_node: "node", to_node: node}}]}
  #   |> Cluster.reroute
  #   |> Elastex.run(conn)
  #
  #   assert resp == nil
  # end


  test "update_settings" do
    resp = %{transient: %{"discovery.zen.minimum_master_nodes" => nil}}
    |> Cluster.update_settings
    |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"acknowledged" => acknowledged}}} = resp
    assert acknowledged == true
  end


  test "get_settings" do
    resp =  Cluster.get_settings |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"persistent" => persistant,
                                      "transient" => transient}}} = resp

    assert persistant == %{}
    assert transient == %{}
  end


  test "node_stats" do
    resp = Cluster.node_stats |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"nodes" => _nodes}, status_code: status_code}} = resp
    assert status_code == 200
  end


  test "node_stats with index", context do
    resp = Cluster.node_stats(context.node) |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"nodes" => _nodes}, status_code: status_code}} = resp
    assert status_code == 200
  end


  test "node_stats with index and stats", context do
    resp = Cluster.node_stats(context.node, "jvm") |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"nodes" => _nodes}, status_code: status_code}} = resp
    assert status_code == 200
  end


  test "node_info" do
    resp = Cluster.node_info |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"nodes" => _nodes}, status_code: status_code}} = resp
    assert status_code == 200
  end


  test "node_info with nodes", context  do
    resp = Cluster.node_info(context.node) |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"nodes" => _nodes}, status_code: status_code}} = resp
    assert status_code == 200
  end


  test "node_info nodes and info", context do
    resp = Cluster.node_info(context.node, "process") |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{body: %{"nodes" => _nodes}, status_code: status_code}} = resp
    assert status_code == 200
  end


  test "node_hot_threads" do
    resp = Cluster.node_hot_threads |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
  end


  test "node_hot_threads with nodes", context do
    resp = Cluster.node_hot_threads(context.node) |> Elastex.run(conn)

    {:ok, %HTTPoison.Response{status_code: status_code}} = resp
    assert status_code == 200
  end


end
