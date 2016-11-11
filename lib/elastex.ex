defmodule Elastex do
  alias Elastex.Helper
  alias Elastex.Builder
  alias Elastex.Web


  @doc """
  """
  @spec run(Builder.t, Map.t) :: any
  def run(req, conn) do
    build(req, conn) |> Web.http_call
  end


  @doc """
  Builds request for http call.
  """
  @spec build(Builder.t, Map.t) :: Builder.t
  def build(req, conn) do
    conn_url = Map.get(conn, :url, "")
    req_url  = req.url     || ""
    headers  = req.headers || []
    options  = req.options || []
    params   = req.params  || []

    %Builder{
      body:    req.body,
      method:  req.method,
      url:     Helper.path([conn_url, req_url]),
      options: Keyword.merge([params: params], options),
      headers: Keyword.merge([accept: "application/json"], headers),
      action: req.action
    }
  end


end
