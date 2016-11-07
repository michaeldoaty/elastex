defmodule Elastex.Index do
  @moduledoc """
   Follows the Elasticsearch
   [Indices API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices.html).
  """

  @behaviour Elastex.Builder.Extender

  alias Elastex.Helper
  alias Elastex.Builder

  @type int_or_string :: non_neg_integer | String.t
  @type body          :: map | struct | nil


  @doc """
  Instantiates an index with default settings.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)

  ## Examples
      iex> Elastex.Index.create("twitter")
      %Elastex.Builder {
        url:    "twitter",
        body:   nil,
        method: :put,
      }
  """
  @spec create(String.t) :: Builder.t
  def create(index), do: create(nil, index)


  @doc """
  Instantiates an index with settings.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)

  ## Examples
      iex> settings = %{number_of_shards: 3}
      iex> Elastex.Index.create(settings, "twitter")
      %Elastex.Builder {
        url:    "twitter",
        body:   %{number_of_shards: 3},
        method: :put,
      }
  """
  @spec create(body, String.t) :: Builder.t
  def create(body, index) do
    %Builder{
      body: body,
      url: index,
      method: :put
    }
  end


  @doc """
  Deletes an index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html)

  ## Examples
      iex> Elastex.Index.delete("twitter")
      %Elastex.Builder {
        url:    "twitter",
        method: :delete,
      }
  """
  @spec delete(String.t) :: Builder.t
  def delete(index) do
    %Builder{
      url: index,
      method: :delete
    }
  end


  @doc """
  Retrieves information about one or more indices.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-index.html)

  ## Examples
      iex> Elastex.Index.get("twitter")
      %Elastex.Builder {
        url:    "twitter",
        method: :get,
      }
  """
  @spec get(String.t) :: Builder.t
  def get(index) do
    %Builder{
      url: index,
      method: :get
    }
  end


  @doc """
  Checks if index exists

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html)

  ## Examples
      iex> Elastex.Index.exists("twitter")
      %Elastex.Builder {
        url:    "twitter",
        method: :head,
      }
  """
  @spec exists(String.t) :: Builder.t
  def exists(index) do
    %Builder{
      url: index,
      method: :head
    }
  end


  @doc """
  Closes an index

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)

  ## Examples
      iex> Elastex.Index.close("twitter")
      %Elastex.Builder {
        url:    "twitter/_close",
        method: :post,
      }
  """
  @spec close(String.t) :: Builder.t
  def close(index) do
    %Builder{
      url: Helper.path([index, "_close"]),
      method: :post
    }
  end


  @doc """
  Opens an index

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)

  ## Examples
      iex> Elastex.Index.open("twitter")
      %Elastex.Builder {
        url:    "twitter/_open",
        method: :post,
      }
  """
  @spec open(String.t) :: Builder.t
  def open(index) do
    %Builder{
      url: Helper.path([index, "_open"]),
      method: :post
    }
  end


  @doc """
  Shrinks an index

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-shrink-index.html)

  ## Examples
      iex> Elastex.Index.shrink("twitter", "new_twitter")
      %Elastex.Builder {
        url:    "twitter/_shrink/new_twitter",
        method: :post,
      }
  """
  @spec shrink(String.t, String.t) :: Builder.t
  def shrink(source_index, target_index) do
    shrink(nil, source_index, target_index)
  end


  @doc """
  Shrinks an index with body

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-shrink-index.html)

  ## Examples
      iex> body = %{settings: %{"index.number_of_replicas" => 1}}
      iex> Elastex.Index.shrink(body, "twitter", "new_twitter")
      %Elastex.Builder {
        url:    "twitter/_shrink/new_twitter",
        body: %{settings: %{"index.number_of_replicas" => 1}},
        method: :post
      }
  """
  @spec shrink(body, String.t, String.t) :: Builder.t
  def shrink(body, source_index, target_index) do
    %Builder{
      url: Helper.path([source_index, "_shrink", target_index]),
      body: body,
      method: :post
    }
  end


  @doc """
  Rollsover an index

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-rollover-index.html)

  ## Examples
      iex> body = %{conditions: %{max_age:  "7d"}}
      iex> Elastex.Index.rollover(body, "twitter")
      %Elastex.Builder {
        url:    "twitter/_rollover",
        body: %{conditions: %{max_age:  "7d"}},
        method: :post
      }
  """
  @spec rollover(body, String.t) :: Builder.t
  def rollover(body, index) do
    rollover(body, index, "")
  end


  @doc """
  Rollsover an index

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-rollover-index.html)

  ## Examples
      iex> body = %{conditions: %{max_age: "7d"}}
      iex> Elastex.Index.rollover(body, "twitter", "new_twitter")
      %Elastex.Builder {
        url:    "twitter/_rollover/new_twitter",
        body: %{conditions: %{max_age:  "7d"}},
        method: :post
      }
  """
  @spec rollover(body, String.t, String.t) :: Builder.t
  def rollover(body, index, named_index) do
    %Builder{
      url: Helper.path([index, "_rollover", named_index]),
      body: body,
      method: :post
    }
  end


  @doc """
  Provides type mappings to an index

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html)

  ## Examples
      iex> body = %{mappings: %{tweet:  %{properties: %{message: %{type: "text"}}}}}
      iex> Elastex.Index.put_mapping(body, "twitter")
      %Elastex.Builder {
        url:    "twitter",
        body: %{mappings: %{tweet:  %{properties: %{message: %{type: "text"}}}}},
        method: :put
      }
  """
  @spec put_mapping(body, String.t) :: Builder.t
  def put_mapping(body, index) do
    %Builder{
      url: Helper.path([index]),
      body: body,
      method: :put
    }
  end


  @doc """
  Provides type mappings to an index with type

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-mapping.html)

  ## Examples
      iex> body = %{mappings: %{tweet:  %{properties: %{message: %{type: "text"}}}}}
      iex> Elastex.Index.put_mapping(body, "twitter", "tweet")
      %Elastex.Builder {
        url:    "twitter/_mapping/tweet",
        body: %{mappings: %{tweet:  %{properties: %{message: %{type: "text"}}}}},
        method: :put
      }
  """
  @spec put_mapping(body, String.t, String.t) :: Builder.t
  def put_mapping(body, index, type) do
    %Builder{
      url: Helper.path([index, "_mapping", type]),
      body: body,
      method: :put
    }
  end


  @doc """
  Gets type mappings for an index

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-mapping.html)

  ## Examples
      iex> Elastex.Index.get_mapping("twitter")
      %Elastex.Builder {
        url:    "twitter/_mapping",
        method: :get
      }
  """
  @spec get_mapping(String.t) :: Builder.t
  def get_mapping(index) do
    get_mapping(index, "")
  end


  @doc """
  Gets type mappings for an index and type

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-mapping.html)

  ## Examples
      iex> Elastex.Index.get_mapping("twitter", "tweet")
      %Elastex.Builder {
        url:    "twitter/_mapping/tweet",
        method: :get
      }
  """
  @spec get_mapping(String.t, String.t) :: Builder.t
  def get_mapping(index, type) do
    %Builder{
      url: Helper.path([index, "_mapping", type]),
      method: :get
    }
  end


  @doc """
  Gets type mappings for a field(s)

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-field-mapping.html)

  ## Examples
      iex> Elastex.Index.get_field_mapping("twitter", "tweet", "message")
      %Elastex.Builder {
        url:    "twitter/_mapping/tweet/field/message",
        method: :get
      }
  """
  @spec get_field_mapping(String.t, String.t, String.t) :: Builder.t
  def get_field_mapping(index, type, field) do
    %Builder{
      url: Helper.path([index, "_mapping", type, "field", field]),
      method: :get
    }
  end


  @doc """
  Checks if type exists

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-types-exists.html)

  ## Examples
      iex> Elastex.Index.type_exists("twitter", "tweet")
      %Elastex.Builder {
        url:    "twitter/_mapping/tweet",
        method: :head
      }
  """
  @spec type_exists(String.t, String.t) :: Builder.t
  def type_exists(index, type) do
    %Builder{
      url: Helper.path([index, "_mapping", type]),
      method: :head
    }
  end


  @doc """
  Aliases an index with a name.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html)

  ## Examples
      iex> body = %{actions: [%{add: %{index: "test_2", alias: "test"}}]}
      iex> Elastex.Index.aliases(body)
      %Elastex.Builder {
        url:    "_aliases",
        body:   %{actions: [%{add: %{index: "test_2", alias: "test"}}]},
        method: :post
      }
  """
  @spec aliases(body) :: Builder.t
  def aliases(body) do
    %Builder{
      url: "_aliases",
      body: body,
      method: :post
    }
  end


  @doc """
  Adds a single alias for an index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html)

  ## Examples
      iex> Elastex.Index.add_alias("twitter", "tw")
      %Elastex.Builder {
        url:    "twitter/_alias/tw",
        method: :put
      }
  """
  @spec add_alias(String.t, String.t) :: Builder.t
  def add_alias(index, name) do
    %Builder{
      url: Helper.path([index, "_alias", name]),
      method: :put
    }
  end


  @doc """
  Adds a single alias for an index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html)

  ## Examples
      iex> body = %{actions: [%{add: %{index: "test_2", alias: "test"}}]}
      iex> Elastex.Index.add_alias(body, "twitter", "tw")
      %Elastex.Builder {
        url:    "twitter/_alias/tw",
        body:   %{actions: [%{add: %{index: "test_2", alias: "test"}}]},
        method: :put
      }
  """
  @spec add_alias(body, String.t, String.t) :: Builder.t
  def add_alias(body, index, name) do
    %Builder{
      url: Helper.path([index, "_alias", name]),
      body: body,
      method: :put
    }
  end


  @doc """
  Gets an alias for an index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html)

  ## Examples
      iex> Elastex.Index.get_alias("twitter", "tw")
      %Elastex.Builder {
        url:    "twitter/_alias/tw",
        method: :get
      }
  """
  @spec get_alias(String.t, String.t) :: Builder.t
  def get_alias(index, name) do
    %Builder{
      url: Helper.path([index, "_alias", name]),
      method: :get
    }
  end


  @doc """
  Deletes an alias for an index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html)

  ## Examples
      iex> Elastex.Index.delete_alias("twitter", "tw")
      %Elastex.Builder {
        url:    "twitter/_alias/tw",
        method: :delete
      }
  """
  @spec delete_alias(String.t, String.t) :: Builder.t
  def delete_alias(index, name) do
    %Builder{
      url: Helper.path([index, "_alias", name]),
      method: :delete
    }
  end


  @doc """
  Checks for an alias for an index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-aliases.html)

  ## Examples
      iex> Elastex.Index.alias_exists("twitter", "tw")
      %Elastex.Builder {
        url:    "twitter/_alias/tw",
        method: :head
      }
  """
  @spec alias_exists(String.t, String.t) :: Builder.t
  def alias_exists(index, name) do
    %Builder{
      url: Helper.path([index, "_alias", name]),
      method: :head
    }
  end


  @doc """
  Changes all index level settings in real time.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-update-settings.html)

  ## Examples
      iex> body = %{index: %{number_of_replicas: 4}}
      iex> Elastex.Index.update_settings(body)
      %Elastex.Builder {
        url:    "_settings",
        body:   %{index: %{number_of_replicas: 4}},
        method: :put
      }
  """
  @spec update_settings(body) :: Builder.t
  def update_settings(body) do
    %Builder{
      url: "_settings",
      body: body,
      method: :put
    }
  end


  @doc """
  Changes specific index level settings in real time.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-update-settings.html)

  ## Examples
      iex> body = %{index: %{number_of_replicas: 4}}
      iex> Elastex.Index.update_settings(body, "twitter")
      %Elastex.Builder {
        url:    "twitter/_settings",
        body:   %{index: %{number_of_replicas: 4}},
        method: :put
      }
  """
  @spec update_settings(body, String.t) :: Builder.t
  def update_settings(body, index) do
    %Builder{
      url: Helper.path([index, "_settings"]),
      body: body,
      method: :put
    }
  end


  @doc """
  Retrieves settings of index or indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-settings.html)

  ## Examples
      iex> Elastex.Index.get_settings("twitter")
      %Elastex.Builder {
        url:    "twitter/_settings",
        method: :get
      }
  """
  @spec get_settings(String.t) :: Builder.t
  def get_settings(index) do
    %Builder{
      url: Helper.path([index, "_settings"]),
      method: :get
    }
  end


  @doc """
  Performs the analysis process on text and returns
  the token breakdown.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-analyze.html)

  ## Examples
      iex> body = %{analyzer: 'standard', text: 'this is a test'}
      iex> Elastex.Index.analyze(body)
      %Elastex.Builder {
        url:    "_analyze",
        body: %{analyzer: 'standard', text: 'this is a test'},
        method: :get
      }
  """
  @spec analyze(body) :: Builder.t
  def analyze(body), do: analyze(body, "")


  @doc """
  Performs the analysis process on text and returns
  the token breakdown.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-analyze.html)

  ## Examples
      iex> body = %{analyzer: 'standard', text: 'this is a test'}
      iex> Elastex.Index.analyze(body, "twitter")
      %Elastex.Builder {
        url:    "twitter/_analyze",
        body: %{analyzer: 'standard', text: 'this is a test'},
        method: :get
      }
  """
  @spec analyze(body, String.t) :: Builder.t
  def analyze(body, index) do
    %Builder{
      url: Helper.path([index, "_analyze"]),
      method: :get,
      body: body
    }
  end


  @doc """
  Defines a template that will automatically be applied when new indices are created

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html)

  ## Examples
      iex> body = %{template: "te*", settings: %{number_of_shards: 1}}
      iex> Elastex.Index.add_template(body, "template1")
      %Elastex.Builder {
        url:    "_template/template1",
        body: %{template: "te*", settings: %{number_of_shards: 1}},
        method: :put
      }
  """
  @spec add_template(body, String.t) :: Builder.t
  def add_template(body, template) do
    %Builder{
      url: Helper.path(["_template", template]),
      method: :put,
      body: body
    }
  end


  @doc """
  Deletes a template.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html)

  ## Examples
      iex> Elastex.Index.delete_template("template1")
      %Elastex.Builder {
        url:    "_template/template1",
        method: :delete
      }
  """
  @spec delete_template(String.t) :: Builder.t
  def delete_template(template) do
    %Builder{
      url: Helper.path(["_template", template]),
      method: :delete
    }
  end


  @doc """
  Retrieves a template

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html)

  ## Examples
      iex> Elastex.Index.get_template("template1")
      %Elastex.Builder {
        url:    "_template/template1",
        method: :get
      }
  """
  @spec get_template(String.t) :: Builder.t
  def get_template(template) do
    %Builder{
      url: Helper.path(["_template", template]),
      method: :get
    }
  end


  @doc """
  Checks the existence of a template.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html)

  ## Examples
      iex> Elastex.Index.template_exists("template1")
      %Elastex.Builder {
        url:    "_template/template1",
        method: :head
      }
  """
  @spec template_exists(String.t) :: Builder.t
  def template_exists(template) do
    %Builder{
      url: Helper.path(["_template", template]),
      method: :head
    }
  end


  @doc """
  Provides statistics on different operations happening on all indicies.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-stats.html)

  ## Examples
      iex> Elastex.Index.stats()
      %Elastex.Builder {
        url:    "_stats",
        method: :get
      }
  """
  @spec stats() :: Builder.t
  def stats(), do: stats("")


  @doc """
  Provides statistics on different operations happening on an index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-stats.html)

  ## Examples
      iex> Elastex.Index.stats("twitter")
      %Elastex.Builder {
        url:    "twitter/_stats",
        method: :get
      }
  """
  @spec stats(String.t) :: Builder.t
  def stats(index) do
    %Builder{
      url: Helper.path([index, "_stats"]),
      method: :get
    }
  end


  @doc """
  Gets low level segment information that a Lucene index (shard-level) is
  built with for all indicies.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-segments.html)

  ## Examples
      iex> Elastex.Index.segments()
      %Elastex.Builder {
        url:    "_segments",
        method: :get
      }
  """
  @spec segments() :: Builder.t
  def segments(), do: segments("")


  @doc """
  Gets low level segment information that a Lucene index (shard-level) is
  built with for an index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-segments.html)

  ## Examples
      iex> Elastex.Index.segments("twitter")
      %Elastex.Builder {
        url:    "twitter/_segments",
        method: :get
      }
  """
  @spec segments(String.t) :: Builder.t
  def segments(index) do
    %Builder{
      url: Helper.path([index, "_segments"]),
      method: :get
    }
  end


  @doc """
  Provides insight into on-going index shard recoveries cluster wide.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-recovery.html)

  ## Examples
      iex> Elastex.Index.recovery()
      %Elastex.Builder {
        url:    "_recovery",
        method: :get
      }
  """
  @spec recovery() :: Builder.t
  def recovery(), do: recovery("")


  @doc """
  Provides insight into on-going index shard recoveries for a specific index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-recovery.html)

  ## Examples
      iex> Elastex.Index.recovery()
      %Elastex.Builder {
        url:    "_recovery",
        method: :get
      }
  """
  @spec recovery(String.t) :: Builder.t
  def recovery(index) do
    url = Path.join([index, "_recovery"])
    %Builder{
      url: url,
      method: :get
    }
  end


  @doc """
  Provides store information for shard copies of all indices.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-shards-stores.html)

  ## Examples
      iex> Elastex.Index.shard_stores()
      %Elastex.Builder {
        url:    "_shard_stores",
        method: :get
      }
  """
  @spec shard_stores() :: Builder.t
  def shard_stores(), do: shard_stores("")


  @doc """
  Provides store information for shard copies of a specific index.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-shards-stores.html)

  ## Examples
      iex> Elastex.Index.shard_stores("twitter")
      %Elastex.Builder {
        url:    "twitter/_shard_stores",
        method: :get
      }
  """
  @spec shard_stores(String.t) :: Builder.t
  def shard_stores(index) do
    %Builder{
      url: Helper.path([index, "_shard_stores"]),
      method: :get
    }
  end


  @doc """
  Clears all or specific cache associated with all indicies.

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-clearcache.html)

  ## Examples
      iex> Elastex.Index.clear_cache()
      %Elastex.Builder {
        url:    "_cache/clear",
        method: :post
      }
  """
  @spec clear_cache() :: Builder.t
  def clear_cache(), do: clear_cache("")


  @doc """
  Clears all or specific cache associated with on or more indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-clearcache.html)

  ## Examples
      iex> Elastex.Index.clear_cache("twitter")
      %Elastex.Builder {
        url:    "twitter/_cache/clear",
        method: :post
      }
  """
  @spec clear_cache(String.t) :: Builder.t
  def clear_cache(index) do
    %Builder{
      url: Helper.path([index, "_cache/clear"]),
      method: :post
    }
  end


  @doc """
  Flushes all indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-flush.html)

  ## Examples
      iex> Elastex.Index.flush()
      %Elastex.Builder {
        url:    "_flush",
        method: :post
      }
  """
  @spec flush() :: Builder.t
  def flush(), do: flush("")


  @doc """
  Flushes one or more indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-flush.html)

  ## Examples
      iex> Elastex.Index.flush("twitter")
      %Elastex.Builder {
        url:    "twitter/_flush",
        method: :post
      }
  """
  @spec flush(String.t) :: Builder.t
  def flush(index) do
    %Builder{
      url: Helper.path([index, "_flush"]),
      method: :post
    }
  end


  @doc """
  Initiates a synched flush manually on all indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-synced-flush.html)

  ## Examples
      iex> Elastex.Index.synced_flush()
      %Elastex.Builder {
        url:    "_flush/synced",
        method: :post
      }
  """
  @spec synced_flush() :: Builder.t
  def synced_flush(), do: synced_flush("")


  @doc """
  Initiates a synched flush manually on one or more indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-synced-flush.html)

  ## Examples
      iex> Elastex.Index.synced_flush("twitter")
      %Elastex.Builder {
        url:    "twitter/_flush/synced",
        method: :post
      }
  """
  @spec synced_flush(String.t) :: Builder.t
  def synced_flush(index) do
    url = Path.join([index, "_flush/synced"])
    %Builder{
      url: url,
      method: :post
    }
  end


  @doc """
  Explicitly refreshes all indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-refresh.html)

  ## Examples
      iex> Elastex.Index.refresh()
      %Elastex.Builder {
        url:    "_refresh",
        method: :post
      }
  """
  @spec refresh() :: Builder.t
  def refresh(), do: refresh("")


  @doc """
  Explicitly refreshes one or more indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-refresh.html)

  ## Examples
      iex> Elastex.Index.refresh("twitter")
      %Elastex.Builder {
        url:    "twitter/_refresh",
        method: :post
      }
  """
  @spec refresh(String.t) :: Builder.t
  def refresh(index) do
    %Builder{
      url: Helper.path([index, "_refresh"]),
      method: :post
    }
  end


  @doc """
  Merges all indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-forcemerge.html)

  ## Examples
      iex> Elastex.Index.force_merge()
      %Elastex.Builder {
        url:    "_forcemerge",
        method: :post
      }
  """
  @spec force_merge() :: Builder.t
  def force_merge(), do: force_merge("")


  @doc """
  Merges one or more indicies

  [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-forcemerge.html)

  ## Examples
      iex> Elastex.Index.force_merge("twitter")
      %Elastex.Builder {
        url:    "twitter/_forcemerge",
        method: :post
      }
  """
  @spec force_merge(String.t) :: Builder.t
  def force_merge(index) do
    %Builder{
      url: Helper.path([index, "_forcemerge"]),
      method: :post
    }
  end


  @doc """
  Adds params to document builders

  ## Examples
      iex> builder = %Elastex.Builder{}
      iex> Elastex.Index.params(builder, [q: "user:mike"])
      %Elastex.Builder {
        params: [q: "user:mike"]
      }
  """
  @spec params(Builder.t, Keyword.t) :: Builder.t
  def params(builder, params) do
    Helper.params(builder, params)
  end


end
