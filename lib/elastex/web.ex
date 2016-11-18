defmodule Elastex.Web do
  @moduledoc """
    This module is used to override HTTPoison.Base.
    It is not meant for general use.
  """

  use HTTPoison.Base

  @doc false
  def http_call(%{action: :multi_search} = m) do
    request(m.method, m.url, m.body, m.headers, m.options)
  end


  @doc false
  def http_call(%{action: :document_bulk} = m) do
    request(m.method, m.url, m.body, m.headers, m.options)
  end


  @doc false
  def http_call(m) do
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
  def process_response_body(unparsed_body) do
    case Poison.decode(unparsed_body) do
      {:ok, body} -> body
      _ -> unparsed_body
    end
  end


end
