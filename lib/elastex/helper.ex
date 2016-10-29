defmodule Elastex.Helper do
  @moduledoc """
   Contains helper functions for other modules
  """

  @doc """
  Creates a string from list of values
  """
  def path(list) do
    list
    |> Enum.map(&to_string/1)
    |> Path.join
  end


  @doc """
  Adds params to builder
  """
  @spec params(Builder.t, Keyword.t) :: Builder.t
  def params(builder, params) do
    Map.update builder, :params, [], fn(value) ->
      Keyword.merge(value || [], params)
    end
  end


  @doc """
  Builds request for http call.
  """
  def build(req, conn) do
    conn_url = Map.get(conn, :url, "")
    req_url  = req.url     || ""
    headers  = req.headers || []
    options  = req.options || []
    params   = req.params  || []

    %{body:    req.body,
      method:  req.method,
      url:     path([conn_url, req_url]),
      options: Keyword.merge([params: params], options),
      headers: Keyword.merge([accept: "application/json"], headers),
      action: req.action
    }
  end


  # @doc """
  # Gets body from a parsed_response.
  #
  # This function takes a parsed_response `{:ok, %{body: body}}}`
  # and attempts to return the body map.
  # """
  # def get_body(parsed_response) do
  #   case parsed_response do
  #     {:ok, %{body: body}} ->
  #       body
  #   _ ->
  #     {:error, "unable to get body"}
  #   end
  # end


  # @doc """
  # """
  # def get_body!(parsed_response) do
  #   {:ok, %{body: body}} = parsed_response
  # end


  # @doc """
  # Gets hits from a parsed_response.
  #
  # This functions takes a parsed_response `{:ok, %{body: {:ok, %{"hits" => hits}}}}`
  # and attempts to return the hits map.
  # If there are any error tuples this function will return nil.
  # """
  # def get_hits(parsed_response) do
  #   case parsed_response do
  #     {:ok, %{body: {:ok, %{"hits" => hits}}}} ->
  #       hits
  #     _ ->
  #       %{}
  #   end
  # end


  # @doc """
  # """
  # def put_maybe(m, k, v) do
  #   if v do
  #     Map.put(m, k, v)
  #   else
  #     m
  #   end
  # end

end
