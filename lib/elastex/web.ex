defmodule Elastex.Web do
  use HTTPoison.Base


  @doc """
  Takes a map, encodes the body, and makes an http call.
  Returns a parse_response of `{:ok, value}` or `{:error, value}`
  """
  def http_call(%{action: :multi_search} = m) do
    request(m.method, m.url, m.body, m.headers, m.options)
  end

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


  def process_response_body(unparsed_body) do
    case Poison.decode(unparsed_body) do
      {:ok, body} -> body
      _ -> unparsed_body
    end
  end

end
