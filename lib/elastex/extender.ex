defmodule Elastex.Extender do
  @moduledoc """
   This module contains functions extended by other modules
  """

  alias Elastex.Builder
  alias Elastex.Helper


  @callback params(%Builder{}, keyword(String.t)) :: %Builder{params: keyword(String.t)}
  @callback extend_url(%Builder{}, list(String.t)) :: %Builder{url: String.t}


  @doc """
  Adds params to builder

  ## Examples
      iex> Elastex.Extender.params(%Elastex.Builder{}, [q: "user:mike"])
      %Elastex.Builder {
        params: [q: "user:mike"]
      }
  """
  @spec params(%Builder{}, keyword(String.t)) :: %Builder{params: keyword(String.t)}
  def params(builder, params) do
    Map.update builder, :params, [], fn(value) ->
      Keyword.merge(value || [], params)
    end
  end


  @doc """
  Extends the url builder's url

  ## Examples
      iex> builder = %Elastex.Builder{url: "twitter"}
      iex> Elastex.Extender.extend_url(builder, ["tweet"])
      %Elastex.Builder {
        url: "twitter/tweet"
      }
  """
  @spec extend_url(%Builder{}, list(String.t)) :: %Builder{}
  def extend_url(builder, list) do
    Map.update builder, :url, "", fn (url) ->
      Helper.path(List.flatten([url, list]))
    end
  end


end
