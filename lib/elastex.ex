defmodule Elastex do
  alias Elastex.Web
  alias Elastex.Helper


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
  Builds the request and makes an http call.

  This function returns `{:ok, response}` or `{:error, response}`.
  Response will be a map containing body, headers, and status code.
  Body will be `{:ok, value}` or `{:error, value}`.
  """
  def run(%{method: nil}), do: {:error, "unknown method name"}

  def run(%{url: ""}), do: {:error, "missing url argument"}

  def run(req, conn) do
    Helper.build(req, conn) |> Web.http_call
  end


  @doc """
  Builds the request and makes an http call throwing if any errors are found.
  """
  def run!(req, conn) do
    #TODO:MD Fix
    # b = Helper.build(req, conn)
    # body = Poison.encode!(Map.get(req, :body, ""))
    # Elastex.Web.request(b.method, b.url, body, b.headers, b.options)
  end

end
