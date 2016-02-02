defmodule Elastex do

  @doc """
  Creates a custom request.
  """
  def custom(method, url), do: custom("", method, url)

  def custom(body, method, url) do
    %{url: url, method: method, body: body}
  end


  @doc """
  Add params to request.
  """
  def params(m, params_list) do
    Map.put(m, :params, params_list)
  end


  @doc """
  Adds headers to request
  """
  def headers(m, headers_list) do
    Map.put(m, :headers, headers_list)
  end


  @doc """
  Adds http options to request
  """
  def http_options(m, options_list) do
    Map.put(m, :options, options_list)
  end


  @doc """
  Extends url by appending to current url.
  """
  def extend_url(req, url) do
    current_url = Map.get(req, :url, "")
    new_url = Path.join([current_url, url])
    Map.put(req, :url, new_url)
  end


  @doc """
  Builds request for http call.
  """
  def build(req, conn) do
    conn_url = Map.get(conn, :url, "")
    req_url  = Map.get(req, :url, "")
    headers  = Map.get(req, :headers, [])
    options  = Map.get(req, :options, [])
    params   = Map.get(req, :params, [])
    body     = Map.get(req, :body, "")

    %{body:    Poison.encode!(body),
      method:  Map.get(req, :method, nil),
      url:     Path.join([conn_url, req_url]),
      options: Keyword.merge([params: params], options),
      headers: Keyword.merge([accept: "application/json"], headers)}
  end


  @doc """
  Makes an http call.
  """
  def run(req, conn) do
    #TODO:MD
    # - mark errors
    # - check nil method
    # - check for body result
    b = build(req, conn)
    HTTPoison.request(b.method, b.url, b.body, b.headers, b.options)
  end


  @doc """
  Makes an http call throwing if any errors are found.
  """
  def run!(req, conn) do
    b = build(req, conn)
    HTTPoison.request(b.method, b.url, b.body, b.headers, b.options)
  end

end
