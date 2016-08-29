defmodule Elastex.Search do
  @moduledoc """
   Follows the Elasticsearch
   [Search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html).
  """

  alias Elastex.Helper
  alias Elastex.Builder

  @type body :: map | struct | nil


  @doc """
  Executes a search query.

  Useful for URI searches.

  ## Examples
      iex> Elastex.Search.query
      %Elastex.Builder {
        url: "_search",
        method: :post,
        action: :search_query,
      }

  ##### with params
      iex> Elastex.Search.query |> Elastex.Search.params([q: "user:kimchy"])
      %Elastex.Builder {
        url: "_search",
        method: :post,
        action: :search_query,
        params: [q: "user:kimchy"]
      }
  """
  @spec query() :: Builder.t
  def query do
    %Builder {
      url: "_search",
      method: :post,
      action: :search_query
    }
  end

  @doc """
  Executes a search query with a body.

  ## Examples
      iex> body = %{query: %{term: %{user: "kimchy"}}}
      iex> Elastex.Search.query(body)
      %Elastex.Builder {
        url: "_search",
        body: %{query: %{term: %{user: "kimchy"}}},
        method: :post,
        action: :search_query,
      }
  """
  @spec query(body) :: Builder.t
  def query(body) do
    %Builder {
      url: "_search",
      body: body,
      action: :search_query,
      method: :post
    }
  end

  @doc """
  Executes a search query with a body and index.

  ## Examples
      iex> body = %{query: %{term: %{user: "kimchy"}}}
      iex> Elastex.Search.query(body, "twitter")
      %Elastex.Builder {
        url: "twitter/_search",
        body: %{query: %{term: %{user: "kimchy"}}},
        method: :post,
        index: "twitter",
        action: :search_query
      }
  """
  @spec query(body, String.t) :: Builder.t
  def query(body, index) do
    %Builder {
      url: Helper.path([index, "_search"]),
      body: body,
      index: index,
      action: :search_query,
      method: :post
    }
  end

  @doc """
  Executes a search query with a body, index, and type.

  ## Examples
      iex> body = %{query: %{term: %{user: "kimchy"}}}
      iex> Elastex.Search.query(body, "twitter", "tweet")
      %Elastex.Builder {
        url: "twitter/tweet/_search",
        body: %{query: %{term: %{user: "kimchy"}}},
        index: "twitter",
        type: "tweet",
        action: :search_query,
        method: :post
      }
  """
  @spec query(body, String.t, String.t) :: Builder.t
  def query(body, index, type) do
    %Builder {
      url: Helper.path([index, type, "_search"]),
      body: body,
      index: index,
      type: type,
      action: :search_query,
      method: :post
    }
  end


  @doc """
  Allows use of mustache templating language to pre-render search requests.

  ## Examples
      iex> body = %{inline: %{query: %{match: %{title: "{{query_string}}"}}}}
      iex> Elastex.Search.template(body)
      %Elastex.Builder {
        url: "template",
        body: %{inline: %{query: %{match: %{title: "{{query_string}}"}}}},
        method: :post
      }
  """
  @spec template(body) :: Builder.t
  def template(body) do
    %Builder {
      url: "template",
      body: body,
      method: :post
    }
  end


  @doc """
  Returns indices and shards that a search request would be executed against
  using an index.

  ## Examples
      iex> Elastex.Search.shards("twitter")
      %Elastex.Builder {
        url: "twitter/_search_shards",
        method: :get,
        index: "twitter",
        type: ""
      }
  """
  @spec shards(String.t) :: Builder.t
  def shards(index), do: shards(index, "")

  @doc """
  Returns indices and shards that a search request would be executed against
  using an index and a type.

  ## Examples
      iex> Elastex.Search.shards("twitter", "tweet")
      %Elastex.Builder {
        url: "twitter/tweet/_search_shards",
        method: :get,
        index: "twitter",
        type: "tweet"
      }
  """
  @spec shards(String.t, String.t) :: Builder.t
  def shards(index, type) do
    url = Helper.path([index, type, "_search_shards"])
    %Builder {
      url: url,
      index: index,
      type: type,
      method: :get
    }
  end


  @doc """
  Suggests similar looking terms based on a provided text.

  ## Examples
      iex> body = %{"my-suggestion" => %{text: "hi", term: %{field: "body"}}}
      iex> Elastex.Search.suggest(body)
      %Elastex.Builder {
        url: "_suggest",
        body: %{"my-suggestion" => %{text: "hi", term: %{field: "body"}}},
        method: :post
      }
  """
  @spec suggest(body) :: Builder.t
  def suggest(body) do
    %Builder{
      url: "_suggest",
      body: body,
      method: :post
    }
  end


  @doc ~S"""
  Executes several search request in a single call.

  ## Examples
      iex> query_builders = [
      ...> Elastex.Search.query(%{hello: "world"}),
      ...> Elastex.Search.query(%{hello: "world"}, "twitter", "tweet")
      ...> ]
      iex> Elastex.Search.multi_search(query_builders)
      %Elastex.Builder {
        url: "_msearch",
        body: "{}\n{\"hello\":\"world\"}\n{\"index\":\"twitter\"}\n{\"hello\":\"world\"}\n",
        method: :post,
        action: :multi_search
      }
  """
  @spec multi_search([Builder.t]) :: Builder.t
  def multi_search(query_builders) do

    bulk_request = Enum.map_join query_builders, "\n", fn(build) ->
      body = build.body || %{}
      new_body = Map.drop(body, [:search_type, :preference, :routing])

      header = body
        |> Map.merge(build)
        |> Map.take([:index, :search_type, :search_type, :preference, :routing])
        |> Enum.filter(fn {_, v} -> v != nil end)
        |> Enum.into(%{})

      Poison.encode!(header) <> "\n" <> Poison.encode!(new_body)
    end

    %Builder {
      url: "_msearch",
      body: bulk_request <> "\n",
      method: :post,
      action: :multi_search
    }
  end


  @doc """
  Executes a query to get the number of matches for that query.
  """
  def count(index, type), do: count("", index, type)

  def count(body, index, type) do
    url = Path.join([index, type, "_count"])
    %{url: url, body: body, method: :get}
  end


  @doc """
  Validates a potentially expensive query without executing it.
  """
  def validate(body), do: validate(body, "", "")

  def validate(body, index), do: validate(body, index, "")

  def validate(body, index, type) do
    url = Path.join([index, type, "_validate/query"])
    %{url: url, body: body, method: :get}
  end


  @doc """
  Computes a score explanation for a query and a specific document.
  """
  def explain(body, index, type, id) do
    url = Path.join([index, type, "#{id}", "_explain"])
    %{url: url, body: body, method: :get}
  end


  @doc """
  """
  @spec params(Builder.t, Keyword.t) :: Builder.t
  def params(builder, params) do
    Map.update builder, :params, [], fn(value) ->
      Keyword.merge(value || [], params)
    end
  end


end
