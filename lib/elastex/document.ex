defmodule Elastex.Document do
  @moduledoc """
   Follows the Elasticsearch
   [Document API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html).
  """

  alias Elastex.Helper
  alias Elastex.Builder

  @type int_or_string :: non_neg_integer | String.t
  @type body          :: map | struct | nil


  @doc """
  Adds a document in a specific index.

  ## Examples
      iex> Elastex.Document.index(%{hello: "world"}, "twitter", "tweet")
      %Elastex.Builder {
        url:    "twitter/tweet",
        body:   %{hello: "world"},
        method: :post,
        action: :document_index,
        index:  "twitter",
        type:   "tweet"
      }
  """
  @spec index(body, String.t, String.t) :: Builder.t
  def index(body, index, type) do
    %Builder{
      url:    Helper.path([index, type]),
      body:   body,
      method: :post,
      action: :document_index,
      index:  index,
      type:   type
    }
  end


  @doc """
  Adds a document in a specific index with id.

  ## Examples
      iex> Elastex.Document.index(%{hello: "world"}, "twitter", "tweet", 5)
      %Elastex.Builder {
        url:    "twitter/tweet/5",
        body:   %{hello: "world"},
        method: :put,
        action: :document_index,
        index:  "twitter",
        type:   "tweet",
        id:     5
      }
  """
  @spec index(body, String.t, String.t, int_or_string) :: Builder.t
  def index(body, index, type, id) do
    %Builder{
      url:    Helper.path([index, type, id]),
      body:   body,
      method: :put,
      action: :document_index,
      index:  index,
      type:   type,
      id:     id
    }
  end


  @doc """
  Gets a document from the index based on its id.

  ## Examples
      iex> Elastex.Document.get("twitter", "tweet", 5)
      %Elastex.Builder {
        url:    "twitter/tweet/5",
        method: :get
      }
  """
  @spec get(String.t, String.t, int_or_string) :: Builder.t
  def get(index, type, id) do
    %Builder{
      url:    Helper.path([index, type, id]),
      method: :get
    }
  end


  @doc """
  Checks whether a document exists.

  ## Examples
      iex> Elastex.Document.exists("twitter", "tweet", 5)
      %Elastex.Builder {
        url:    "twitter/tweet/5",
        method: :head
      }
  """
  @spec exists(String.t, String.t, int_or_string) :: Builder.t
  def exists(index, type, id) do
    %Builder{
      url:    Helper.path([index, type, id]),
      method: :head
    }
  end


  @doc """
  Deletes all documents from the index and type.

  ## Examples
      iex> Elastex.Document.delete("twitter", "tweet")
      %Elastex.Builder {
        url:    "twitter/tweet",
        method: :delete,
        action: :document_delete,
        index:  "twitter",
        type:   "tweet"
      }
  """
  @spec delete(String.t, String.t) :: Builder.t
  def delete(index, type) do
    %Builder{
      url:    Helper.path([index, type]),
      method: :delete,
      action: :document_delete,
      index:  index,
      type:   type,
    }
  end

  @doc """
  Deletes a document from the index based on its id.

  ## Examples
      iex> Elastex.Document.delete("twitter", "tweet", 5)
      %Elastex.Builder {
        url:    "twitter/tweet/5",
        method: :delete,
        action: :document_delete,
        index:  "twitter",
        type:   "tweet",
        id:     5
      }
  """
  @spec delete(String.t, String.t, int_or_string) :: Builder.t
  def delete(index, type, id) do
    %Builder{
      url:    Helper.path([index, type, id]),
      method: :delete,
      action: :document_delete,
      index:  index,
      type:   type,
      id:     id
    }
  end


  @doc """
  Updates a document based on its id.

  ## Examples
      iex> Elastex.Document.update(%{doc: %{name: "new_name"}}, "twitter", "tweet", 5)
      %Elastex.Builder {
        url:    "twitter/tweet/5/_update",
        body:   %{doc: %{name: "new_name"}},
        method: :post,
        action: :document_update,
        index:  "twitter",
        type:   "tweet",
        id:     5
      }
  """
  @spec update(body, String.t, String.t, int_or_string) :: Builder.t
  def update(body, index, type, id) do
    %Builder{
      url:    Helper.path([index, type, id, "_update"]),
      body:   body,
      method: :post,
      action: :document_update,
      index:  index,
      type:   type,
      id:     id
    }
  end


  @doc """
  Gets multiple documents based on docs array information.

  ## Examples
      iex> docs = %{docs: [%{_index: "website", _type: "blog", _id: 2}]}
      iex> Elastex.Document.mget(docs)
      %Elastex.Builder {
        url:    "_mget",
        body:   %{docs: [%{_index: "website", _type: "blog", _id: 2}]},
        method: :get
      }
  """
  @spec mget(body) :: Builder.t
  def mget(body), do: mget(body, "", "")


  @doc """
  Gets multiple documents based on index and docs array information.

  ## Examples
      iex> docs = %{docs: [%{_type: "blog", _id: 2}]}
      iex> Elastex.Document.mget(docs, "website")
      %Elastex.Builder {
        url:    "website/_mget",
        body:   %{docs: [%{_type: "blog", _id: 2}]},
        method: :get,
      }
  """
  @spec mget(body, String.t) :: Builder.t
  def mget(body, index), do: mget(body, index, "")


  @doc """
  Gets multiple documents based on index, type and docs array information.

  ## Examples
      iex> docs = %{docs: [%{ids: ["1", "2"]}]}
      iex> Elastex.Document.mget(docs, "website", "blog")
      %Elastex.Builder {
        url:    "website/blog/_mget",
        body:   %{docs: [%{ids: ["1", "2"]}]},
        method: :get
      }
  """
  @spec mget(body, String.t, String.t) :: Builder.t
  def mget(body, index, type) do
    %Builder{
      url:    Helper.path([index, type, "_mget"]),
      body:   body,
      method: :get
    }
  end


  @doc ~S"""
  Performs index, create, delete, or update operations in a single call.

  ## Examples
      iex> bulk_requests = [
      ...> Elastex.Document.delete("twitter", "tweet", 5),
      ...> Elastex.Document.index(%{hello: "world"}, "twitter", "tweet")
      ...> ]
      iex> Elastex.Document.bulk(bulk_requests)
      %Elastex.Builder {
        url:    "_bulk",
        body:   "{\"delete\":{\"_type\":\"tweet\",\"_index\":\"twitter\",\"_id\":5}}\n{\"index\":{\"_type\":\"tweet\",\"_index\":\"twitter\"}}\n{\"hello\":\"world\"}\n",
        method: :post,
        action: :document_bulk
      }
  """
  @spec bulk([Builder.t]) :: Builder.t
  def bulk(builders) do
    m = %{
      document_update: "update",
      document_index: "index",
      document_create: "create",
      document_delete: "delete"
    }

    try do
      bulk_request = Enum.map_join builders, "\n", fn(build) ->
        if action = Map.get(m, build.action) do
          build_bulk_request(build, action)
        else
          raise "Request must be from Elastex.Document.delete, Elastex.Document.index, or Elastex.Document.create"
        end
      end

      %Builder{
        url:    "_bulk",
        body:   bulk_request <> "\n",
        method: :post,
        action: :document_bulk
      }

    rescue
      e -> e
    end
  end


  @spec build_bulk_request(Builder.t, String.t) :: any
  defp build_bulk_request(builder, action) do
    action_map = %{
      _index: builder.index,
      _type:  builder.type,
      _id:    builder.id
    }

    action_result = action_map
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.into(%{})

    action_req = %{ action => action_result }

    if builder.body do
      Poison.encode!(action_req) <> "\n" <> Poison.encode!(builder.body)
    else
      Poison.encode!(action_req)
    end
  end


  @doc """
  Returns information and statistics on terms in the fields
  of a particular document.

  ## Examples
      iex> Elastex.Document.term_vectors("twitter", "tweet", "1")
      %Elastex.Builder {
        url:    "twitter/tweet/1/_termvectors",
        method: :get
      }
  """
  @spec term_vectors(String.t, String.t, int_or_string) :: Builder.t
  def term_vectors(index, type, id) do
    %Builder{
      url:    Helper.path([index, type, id, "_termvectors"]),
      method: :get
    }
  end


  @doc """
  Returns information and statistics on terms in the fields
  of a particular document using body options.

  ## Examples
      iex> body = %{fields: ["text"], "positions": true}
      iex> Elastex.Document.term_vectors(body, "twitter", "tweet", "1")
      %Elastex.Builder {
        url:    "twitter/tweet/1/_termvectors",
        body:   %{fields: ["text"], "positions": true},
        method: :get
      }
  """
  @spec term_vectors(body, String.t, String.t, int_or_string) :: Builder.t
  def term_vectors(body, index, type, id) do
    %Builder{
      url:    Helper.path([index, type, id, "_termvectors"]),
      body:   body,
      method: :get
    }
  end


  @doc """
  Gets multiple term vectors at once using body options only.

  ## Examples
      iex> body = %{doc: [%{_index: "twitter", _type: "tweet", _id: 2}]}
      iex> Elastex.Document.mterm_vectors(body)
      %Elastex.Builder {
        url:    "_mtermvectors",
        body:   %{doc: [%{_index: "twitter", _type: "tweet", _id: 2}]},
        method: :get
      }
  """
  @spec mterm_vectors(body) :: Builder.t
  def mterm_vectors(body), do: mterm_vectors(body, "", "")


  @doc """
  Gets multiple term vectors at once using body options and an index.

  ## Examples
      iex> body = %{doc: [%{_index: "twitter", _type: "tweet", _id: 2}]}
      iex> Elastex.Document.mterm_vectors(body, "twitter")
      %Elastex.Builder {
        url:    "twitter/_mtermvectors",
        body:   %{doc: [%{_index: "twitter", _type: "tweet", _id: 2}]},
        method: :get
      }
  """
  @spec mterm_vectors(body, String.t) :: Builder.t
  def mterm_vectors(body, index), do: mterm_vectors(body, index, "")


  @doc """
  Gets multiple term vectors at once using body options, an index and type.

  ## Examples
      iex> body = %{doc: [%{_index: "twitter", _type: "tweet", _id: 2}]}
      iex> Elastex.Document.mterm_vectors(body, "twitter", "tweet")
      %Elastex.Builder {
        url:    "twitter/tweet/_mtermvectors",
        body:   %{doc: [%{_index: "twitter", _type: "tweet", _id: 2}]},
        method: :get
      }
  """
  @spec mterm_vectors(body, String.t, String.t) :: Builder.t
  def mterm_vectors(body, index, type) do
    %Builder{
      url:    Helper.path([index, type, "_mtermvectors"]),
      body:   body,
      method: :get
    }
  end

end
