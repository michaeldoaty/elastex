defmodule Elastex.Cluster do

  @doc """
  Gets a very simple status on the health of a cluster.
  """
  def health(), do: health("")

  def health(index) do
    url = Path.join(["_cluster/health", index])
    %{url: url, method: :get}
  end


  @doc """
  Gets comprehensive state information of cluster.
  """
  def state, do: state("", "")

  def state(index, metrics) do
    url = Path.join(["_cluster/state", metrics, index])
    %{url: url, method: :get}
  end


  @doc """
  Retrieves statistics from a cluster wide perspective.
  """
  def stats do
    %{url: "_cluster/stats", method: :get}
  end


  @doc """
  Retrieves pending tasks from a cluster wide perspective.
  """
  def pending_tasks do
    %{url: "_cluster/pending_tasks", method: :get}
  end


  @doc """
  Executes a reroute allocation command including specific commands.
  """
  def reroute(body) do
    url = Path.join(["_cluster/reroute"])
    %{url: url, method: :post, body: body}
  end


  @doc """
  Retrieve one or more (or all) of the cluster nodes statistics.
  """
  def node_stats(), do: node_stats("", "")

  def node_stats(stats), do: node_stats(stats, "")

  def node_stats(stats, nodes) do
    url = Path.join(["_nodes", nodes, "stats", stats])
    %{url: url, method: :get}
  end


  @doc """
  Retrieve one or more (or all) of the cluster nodes statistics.
  """
  def node_info(), do: node_info("", "")

  def node_info(attributes), do: node_info(attributes, "")

  def node_info(attributes, nodes) do
    url = Path.join(["_nodes", nodes, attributes])
    %{url: url, method: :get}
  end


  @doc """
  Retrieves current hot threads on each node in the cluster.
  """
  def node_hot_threads(node) do
    url = Path.join(["_nodes", node, "hot_threads"])
    %{url: url, method: :get}
  end

end