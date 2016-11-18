defmodule Elastex do
  use HTTPoison.Base

  alias Elastex.Helper
  alias Elastex.Builder


  @doc """
  Runs the request using the elastex url from config file
  """
  @spec run(%Builder{}) :: any
  def run(req) do
    url = Application.get_env(:elastex, :url)
    build(req, %{url: url}) |> http_call
  end


  @doc """
  Runs the request using the url from the conn map parameter
  """
  @spec run(%Builder{}, map()) :: any
  def run(req, conn) do
    build(req, conn) |> http_call
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


  @doc false
  defp http_call(%{action: :multi_search} = m) do
    request(m.method, m.url, m.body, m.headers, m.options)
  end


  @doc false
  defp http_call(%{action: :document_bulk} = m) do
    request(m.method, m.url, m.body, m.headers, m.options)
  end


  @doc false
  defp http_call(m) do
    case Poison.encode(m.body) do
      # this case has a body of nil
      {:ok, "null"} ->
        request(m.method, m.url, "", m.headers, m.options)
      {:ok, body} ->
        request(m.method, m.url, body, m.headers, m.options)
      err ->
        err
    end
  end


  #############################################
  # Extending HTTPoison
  #############################################


  @doc false
  defp process_response_body(unparsed_body) do
    case Poison.decode(unparsed_body) do
      {:ok, body} -> body
      _ -> unparsed_body
    end
  end


end
