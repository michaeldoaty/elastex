defmodule Elastex.Web do
  use HTTPoison.Base


  @doc """
  Takes a map, encodes the body, and makes an http call.
  Returns a parse_response of `{:ok, value}` or `{:error, value}`
  """
  def http_call(m) do
    case Poison.encode(m.body) do
      {:ok, body} ->
        resp = request(m.method, m.url, body, m.headers, m.options)
        parse_response(resp)
      err ->
        err
    end
  end


  @doc """
  Parses HTTPoison.Response into a `:ok` or `:error` tuple containing
  a map or an error reason.
  """
  def parse_response(res) do
    case res do
      {:ok, struct} ->
        {:ok, Map.from_struct(struct)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end


  #############################################
  # Extending HTTPoison
  #############################################


  def process_response_body(body) do
    Poison.decode(body)
  end

end
