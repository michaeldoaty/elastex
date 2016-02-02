defmodule Elastex.Search do

  @doc """
  Executes a search query.
  """
  def query, do: query("", "", "")

  def query(body), do: query(body, "", "")

  def query(body, index), do: query(body, index, "")

  def query(body, index, type) do
    url = Path.join([index, type, "_search"])
    %{url: url, body: body, method: :get}
  end


  @doc """
  Allows use of mustache templating language to pre-render search requests.
  """
  def template(body) do
    %{url: "template", body: body, method: :get}
  end


  @doc """
  Returns indices and shards that a search request would be executed against.
  """
  def shards(index), do: shards(index, "")

  def shards(index, type) do
    url = Path.join([index, type, "_search_shards"])
    %{url: url, method: :get}
  end


  @doc """
  Suggests similar looking terms based on a provided text.
  """
  def suggest(body) do
    %{url: "_suggest", body: body, method: :get}
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

end