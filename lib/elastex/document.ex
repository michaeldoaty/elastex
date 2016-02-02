defmodule Elastex.Document do

  @doc """
  Adds or updates a document in a specific index.
  """
  def index(body, index, type) do
    url = Path.join([index, type])
    %{url: url, body: body, method: :post}
  end

  def index(body, index, type, id) do
    url = Path.join([index, type, "#{id}"])
    %{url: url, body: body, method: :put}
  end


  @doc """
  gets document from a specific index based on its id.
  """
  def get(index, type, id) do
    url = Path.join([index, type, "#{id}"])
    %{url: url, method: :get}
  end


  @doc """
  Deletes document from a specific index based on its id.
  """
  def delete(index, type, id) do
    url = Path.join([index, type, "#{id}"])
    %{url: url, method: :delete}
  end


  @doc """
  Updates a document based on a script provided.
  """
  def update_with_script(body, index, type, id) do
    url = Path.join([index, type, "#{id}", "_update"])
    %{url: url, body: body, method: :post}
  end


  @doc """
  Gets multiple documents based on body, index, or type.
  """
  def mget(body), do: mget(body, "", "")

  def mget(body, index), do: mget(body, index, "")

  def mget(body, index, type) do
    url = Path.join([index, type, "_mget"])
    %{url: url, body: body, method: :get}
  end


  @doc """
  Returns information and statistics on terms in the fields
  of a particular document.
  """
  def term_vectors(index, type, id) do
    url = Path.join([index, type, "#{id}", "_termvectors"])
    %{url: url, method: :get}
  end


  @doc """
  Gets multiple term vectors at once.
  """
  def mterm_vectors(body), do: mterm_vectors(body, "", "")

  def mterm_vectors(body, index), do: mterm_vectors(body, index, "")

  def mterm_vectors(body, index, type) do
    url = Path.join([index, type, "_mtermvectors"])
    %{url: url, body: body, method: :get}
  end

end