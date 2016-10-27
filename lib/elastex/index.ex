defmodule Elastex.Index do

  @doc """
  Instantiates an index with or without a body.
  """
  def create(index), do: create("", index)

  def create(body, index) do
    %{url: index, body: body, method: :put}
  end


  @doc """
  Deletes an existing index.
  """
  def delete(index) do
    %{url: index, method: :delete}
  end


  @doc """
  Retrieves information about one or more indices.
  """
  def get(index) do
    %{url: index, method: :get}
  end


  @doc """
  Checks if index exists.
  """
  def exists(index) do
    %{url: index, method: :head}
  end


  @doc """
  Closes an index.
  """
  def close(index) do
    url = Path.join([index, "_close"])
    %{url: url, method: :post}
  end


  @doc """
  Opens an index
  """
  def open(index) do
    url = Path.join([index, "_open"])
    %{url: url, method: :post}
  end


  @doc """
  Adds a new type to an exisiting index
  or new fields to an exisiting type.
  """
  def put_mapping(body, index) do
    %{url: index, method: :put, body: body}
  end

  def put_mapping(body, index, type) do
    url = Path.join([index, "_mapping", type])
    %{url: url, method: :put, body: body}
  end


  @doc """
  Retrieves mapping definitions for an index or index/type.
  """
  def get_mapping(index), do: get_mapping(index, "")

  def get_mapping(index, type) do
    url = Path.join([index, "_mapping", type])
    %{url: url, method: :get}
  end


  @doc """
  Checks if type exist in index.
  """
  def type_exists(index, type) do
    url = Path.join([index, type])
    %{url: url, method: :head}
  end


  @doc """
  Aliases an index with a name.
  """
  def aliases(body) do
    %{url: "_aliases", method: :post, body: body}
  end


  @doc """
  Adds a single alias
  """
  def add_alias(index, name) do
    url = Path.join([index, "_alias", name])
    %{url: url, method: :put}
  end


  @doc """
  Retrieves existing alias
  """
  def get_alias(index, name) do
    url = Path.join([index, "_alias", name])
    %{url: url, method: :get}
  end


  @doc """
  Deletes an existing alias
  """
  def delete_alias(index, name) do
    url = Path.join([index, "_alias", name])
    %{url: url, method: :delete}
  end


  @doc """
  Updates index level settings.
  """
  def update_settings(body), do: update_settings(body, "")

  def update_settings(body, index) do
    url = Path.join([index, "_settings"])
    %{url: url, method: :put, body: body}
  end


  @doc """
  Retrieves settings of index/indices.
  """
  def get_settings(index) do
    url = Path.join([index, "_settings"])
    %{url: url, method: :get}
  end


  @doc """
  Performs the analysis process on text and returns
  the token breakdown.
  """
  def analyze(body), do: analyze(body, "")

  def analyze(body, index) do
    url = Path.join([index, "_analyze"])
    %{url: url, method: :get, body: body}
  end


  @doc """
  Adds a template.
  """
  def add_template(body, template) do
    url = Path.join(["_template", template])
    %{url: url, method: :put, body: body}
  end


  @doc """
  Deletes a template.
  """
  def delete_template(template) do
    url = Path.join(["_template", template])
    %{url: url, method: :delete}
  end


  @doc """
  Retrieves a template
  """
  def get_template(template) do
    url = Path.join(["_template", template])
    %{url: url, method: :get}
  end


  @doc """
  Checks the existence of a template.
  """
  def template_exists(template) do
    url = Path.join(["_template", template])
    %{url: url, method: :head}
  end


  @doc """
  Adds warmer to a specific index.
  """
  def put_warmer(body, warmer), do: put_warmer(body, "", "", warmer)

  def put_warmer(body, index, warmer), do: put_warmer(body, index, "", warmer)

  def put_warmer(body, index, type, warmer) do
    url = Path.join([index, type, "_warmer", warmer])
    %{url: url, method: :put, body: body}
  end


  @doc """
  Deletes warmer
  """
  def delete_warmer(index, warmer) do
    url = Path.join([index, "_warmer", warmer])
    %{url: url, method: :delete}
  end


  @doc """
  Retrieves warmer
  """
  def get_warmer(index), do: get_warmer(index, "")

  def get_warmer(index, warmer) do
    url = Path.join([index, "_warmer", warmer])
    %{url: url, method: :get}
  end



  @doc """
  Provides statistics on different operations happening on an index.
  """
  def stats(), do: stats("")

  def stats(index) do
    url = Path.join([index, "_stats"])
    %{url: url, method: :get}
  end


  @doc """
  Gets low level segment information that a Lucene index (shard-level) is
  built with.
  """
  def segments(), do: segments("")

  def segments(index) do
    url = Path.join([index, "_segments"])
    %{url: url, method: :get}
  end


  @doc """
  Provides insight into on-going index shard recoveries.
  """
  def recovery(), do: recovery("")

  def recovery(index) do
    url = Path.join([index, "_recovery"])
    %{url: url, method: :get}
  end


  @doc """
  Provides store information for shard copies of indices.
  """
  def shard_stores(), do: shard_stores("")

  def shard_stores(index) do
    url = Path.join([index, "_shard_stores"])
    %{url: url, method: :get}
  end


  @doc """
  Clears all or specific cache associated with an index.
  """
  def clear_cache(), do: clear_cache("")

  def clear_cache(index) do
    url = Path.join([index, "_cache/clear"])
    %{url: url, method: :post}
  end


  @doc """
  Flushes one or more indices.
  """
  def flush(), do: flush("")

  def flush(index) do
    url = Path.join([index, "_flush"])
    %{url: url, method: :post}
  end


  @doc """
  Initiates a synched flush manually.
  """
  def synced_flush(), do: synced_flush("")

  def synced_flush(index) do
    url = Path.join([index, "_flush/synced"])
    %{url: url, method: :post}
  end


  @doc """
  Explicitly refreshes one or more index.
  """
  def refresh(), do: refresh("")

  def refresh(index) do
    url = Path.join([index, "_refresh"])
    %{url: url, method: :post}
  end


  @doc """
  Merges one or more indices
  """
  def force_merge(), do: force_merge("")

  def force_merge(index) do
    url = Path.join([index, "_forcemerge"])
    %{url: url, method: :post}
  end


  @doc """
  Upgrades one or more indices
  """
  def upgrade(), do: upgrade("")

  def upgrade(index) do
    url = Path.join([index, "_upgrade"])
    %{url: url, method: :post}
  end

end
