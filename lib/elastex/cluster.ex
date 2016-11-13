defmodule Elastex.Cluster do
  @moduledoc """
   Follows the Elasticsearch
   [Document API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster.html).
  """

  @behaviour Elastex.Extender

  alias Elastex.Helper
  alias Elastex.Builder
  alias Elastex.Extender


  @doc """
  Gets a very simple status on the health of the cluster.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-health.html)

  ## Examples
      iex> Elastex.Cluster.health()
      %Elastex.Builder {
        url:    "_cluster/health",
        method: :get,
      }
  """
  @spec health() :: %Builder{url: String.t, method: :get}
  def health(), do: health("")


  @doc """
  Gets a very simple status on the health of the cluster using on or more indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-health.html)

  ## Examples
      iex> Elastex.Cluster.health("twitter")
      %Elastex.Builder {
        url:    "_cluster/health/twitter",
        method: :get,
      }
  """
  @spec health(String.t) :: %Builder{url: String.t, method: :get}
  def health(index) do
    %Builder{
      url: Helper.path(["_cluster/health", index]),
      method: :get
    }
  end


  @doc """
  Gets comprehensive state information of the whole cluster.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-state.html)

  ## Examples
      iex> Elastex.Cluster.state()
      %Elastex.Builder {
        url:    "_cluster/state",
        method: :get,
      }
  """
  @spec state() :: %Builder{url: String.t, method: :get}
  def state, do: state("", "")


  @doc """
  Gets comprehensive state information of the whole cluster using metrics.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-state.html)

  ## Examples
      iex> Elastex.Cluster.state("blocks")
      %Elastex.Builder {
        url:    "_cluster/state/blocks",
        method: :get,
      }
  """
  @spec state(String.t) :: %Builder{url: String.t, method: :get}
  def state(metrics), do: state(metrics, "")


  @doc """
  Gets comprehensive state information of the whole cluster using metrics.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-state.html)

  ## Examples
      iex> Elastex.Cluster.state("metadata", "twitter")
      %Elastex.Builder {
        url:    "_cluster/state/metadata/twitter",
        method: :get,
      }
  """
  @spec state(String.t, String.t) :: %Builder{url: String.t, method: :get}
  def state(metrics, index) do
    %Builder{
      url: Helper.path(["_cluster/state", metrics, index]),
      method: :get
    }
  end


  @doc """
  Retrieves statistics from a cluster wide perspective.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-stats.html)

  ## Examples
      iex> Elastex.Cluster.stats()
      %Elastex.Builder {
        url:    "_cluster/stats",
        method: :get,
      }
  """
  @spec stats() :: %Builder{url: String.t, method: :get}
  def stats do
    %Builder{
      url: "_cluster/stats",
      method: :get
    }
  end


  @doc """
  Retrieves pending tasks from a cluster wide perspective.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-pending.html)

  ## Examples
      iex> Elastex.Cluster.pending_tasks()
      %Elastex.Builder {
        url:    "_cluster/pending_tasks",
        method: :get,
      }
  """
  @spec pending_tasks() :: %Builder{url: String.t, method: :get}
  def pending_tasks do
    %Builder{
      url: "_cluster/pending_tasks",
      method: :get
    }
  end


  @doc """
  Executes a reroute allocation command including specific commands.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-reroute.html)

  ## Examples
      iex> body = %{commands: [%{move: %{index: "twitter", shard: 0}}]}
      iex> Elastex.Cluster.reroute(body)
      %Elastex.Builder {
        url:    "_cluster/pending_tasks",
        method: :get,
      }
  """
  @spec reroute(map()) :: %Builder{url: String.t, body: map(), method: :post}
  def reroute(body) do
    %Builder{
      url: "_cluster/reroute",
      body: body,
      method: :post
    }
  end


  @doc """
  Retrieves specific wide cluster settings

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html)

  ## Examples
      iex> Elastex.Cluster.get_settings()
      %Elastex.Builder {
        url:    "_cluster/pending_tasks",
        method: :get
      }
  """
  @spec get_settings() :: %Builder{url: String.t, method: :get}
  def get_settings() do
    %Builder{
      url: "_cluster/settings",
      method: :get
    }
  end


  @doc """
  Updates specific wide cluster settings

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html)

  ## Examples
      iex> body = %{persistant: %{persistant: %{"discovery.zen.minimum_master_notes" => 2}}}
      iex> Elastex.Cluster.update_settings(body)
      %Elastex.Builder {
        url:    "_cluster/pending_tasks",
        body:   %{persistant: %{persistant: %{"discovery.zen.minimum_master_notes" => 2}}},
        method: :get
      }
  """
  @spec update_settings(map()) :: %Builder{url: String.t, body: map(), method: :put}
  def update_settings(body) do
    %Builder{
      url: "_cluster/settings",
      body: body,
      method: :put
    }
  end



  @doc """
  Retrieve stats of all nodes in the cluster

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-stats.html)

  ## Examples
      iex> Elastex.Cluster.node_stats()
      %Elastex.Builder {
        url:    "_node/stats",
        method: :get
      }
  """
  @spec node_stats() :: %Builder{url: String.t, method: :get}
  def node_stats(), do: node_stats("", "")


  @doc """
  Retrieve nodes stats of specific nodes

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-stats.html)

  ## Examples
      iex> Elastex.Cluster.node_stats("nodeId1,nodeId2")
      %Elastex.Builder {
        url:    "_node/nodeId1,nodeId2/stats",
        method: :get
      }
  """
  @spec node_stats(String.t) :: %Builder{url: String.t, method: :get}
  def node_stats(nodes), do: node_stats(nodes, "")


  @doc """
  Retrieve nodes stats of specific nodes and stats

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-stats.html)

  ## Examples
      iex> Elastex.Cluster.node_stats("nodeId1,nodeId2", "process")
      %Elastex.Builder {
        url:    "_node/nodeId1,nodeId2/stats/process",
        method: :get
      }
  """
  @spec node_stats(String.t, String.t) :: %Builder{url: String.t, method: :get}
  def node_stats(nodes, stats) do
    url = Path.join(["_nodes", nodes, "stats", stats])
    %Builder{
      url: url,
      method: :get
    }
  end


  @doc """
  Retrieves information of all the nodes in the cluster

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-info.html)

  ## Examples
      iex> Elastex.Cluster.node_info()
      %Elastex.Builder {
        url:    "_node",
        method: :get
      }
  """
  @spec node_info() :: %Builder{url: String.t, method: :get}
  def node_info(), do: node_info("", "")


  @doc """
  Retrieves information of specific nodes in the cluster

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-info.html)

  ## Examples
      iex> Elastex.Cluster.node_info("nodeId1,nodeId2")
      %Elastex.Builder {
        url:    "_node/nodeId1,nodeId2",
        method: :get
      }
  """
  @spec node_info(String.t) :: %Builder{url: String.t, method: :get}
  def node_info(nodes), do: node_info(nodes, "")


  @doc """
  Retrieves information of specific nodes and info in the cluster

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-info.html)

  ## Examples
      iex> Elastex.Cluster.node_info("nodeId1,nodeId2", "process")
      %Elastex.Builder {
        url:    "_node/nodeId1,nodeId2/process",
        method: :get
      }
  """
  @spec node_info(String.t, String.t) :: %Builder{url: String.t, method: :get}
  def node_info(nodes, info) do
    %Builder{
      url: Helper.path(["_nodes", nodes, info]),
      method: :get
    }
  end


  @doc """
  Retrieves current hot threads on all nodes in the cluster.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-info.html)

  ## Examples
      iex> Elastex.Cluster.node_hot_threads()
      %Elastex.Builder {
        url:    "_nodes/hot_threads",
        method: :get
      }
  """
  @spec node_hot_threads() :: %Builder{url: String.t, method: :get}
  def node_hot_threads(), do: node_hot_threads("")


  @doc """
  Retrieves current hot threads on each node in the cluster.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-info.html)

  ## Examples
      iex> Elastex.Cluster.node_hot_threads("nodeId1,nodeId2")
      %Elastex.Builder {
        url:    "_nodes/hot_threads/process",
        method: :get
      }
  """
  @spec node_hot_threads(String.t) :: %Builder{url: String.t, method: :get}
  def node_hot_threads(nodes) do
    %Builder{
      url: Helper.path(["_nodes", nodes, "hot_threads"]),
      method: :get
    }
  end


  @doc """
  Adds params to document builder

  ## Examples
      iex> builder = %Elastex.Builder{}
      iex> Elastex.Cluster.params(builder, [q: "user:mike"])
      %Elastex.Builder {
        params: [q: "user:mike"]
      }
  """
  @spec params(%Builder{}, keyword(String.t)) :: %Builder{params: keyword(String.t)}
  def params(builder, params) do
    Extender.params(builder, params)
  end


  @doc """
  Extends the url of cluster builder

  ## Examples
      iex> builder = %Elastex.Builder{url: "twitter"}
      iex> Elastex.Cluster.extend_url(builder, ["tweet"])
      %Elastex.Builder {
        url: "twitter/tweet"
      }
  """
  @spec extend_url(%Builder{}, list(String.t)) :: %Builder{url: String.t}
  def extend_url(builder, list) do
    Extender.extend_url(builder, list)
  end


end
