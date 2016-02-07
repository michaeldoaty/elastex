defmodule Elastex.Helper do


  @doc """
  Gets body from a parsed_response.

  This function takes a parsed_response `{:ok, %{body: {:ok, body}}}`
  and attempts to return the body map.
  If there are any error tuples this function will return nil.
  """
  def get_body(parsed_response) do
    case parsed_response do
      {:ok, %{body: {:ok, body}}} ->
        body
      _ ->
        nil
    end
  end


  @doc """
  Gets hits from a parsed_response.

  This functions takes a parsed_response `{:ok, %{body: {:ok, %{"hits" => hits}}}}`
  and attempts to return the hits map.
  If there are any error tuples this function will return nil.
  """
  def get_hits(parsed_response) do
    case parsed_response do
      {:ok, %{body: {:ok, %{"hits" => hits}}}} ->
        hits
      _ ->
        nil
    end
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

    %{body:    Map.get(req, :body, ""),
      method:  Map.get(req, :method, nil),
      url:     Path.join([conn_url, req_url]),
      options: Keyword.merge([params: params], options),
      headers: Keyword.merge([accept: "application/json"], headers)}
  end

end