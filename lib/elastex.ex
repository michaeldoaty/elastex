defmodule Elastex do
  @moduledoc """
   This module contains the run functions used to make a HTTP request
  """

  alias Elastex.Helper
  alias Elastex.Builder
  alias Elastex.Web


  @doc """
  Runs the request using the elastex url from config file
  """
  @spec run(%Builder{}) :: any
  def run(req) do
    url = Application.get_env(:elastex, :url)
    build(req, %{url: url}) |> Web.http_call
  end


  @doc """
  Runs the request using the url from the conn map parameter
  """
  @spec run(%Builder{}, map()) :: any
  def run(req, conn) do
    build(req, conn) |> Web.http_call
  end


  @doc """
  Builds request for http call.
  """
  @spec build(%Builder{}, map()) :: %Builder{}
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
