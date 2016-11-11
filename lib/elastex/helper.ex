defmodule Elastex.Helper do
  @moduledoc """
   Contains helper functions for other modules
  """


  @doc """
  Creates a path string from list of values.

  `to_string` is call on the list of values so they must implement
  the String.Chars protocol.

  ## Examples
      iex> Elastex.Helper.path(["hello", "world", 1])
      "hello/world/1"
  """
  @spec path(list(String.t)) :: String.t
  def path(list) do
    list
    |> Enum.map(&to_string/1)
    |> Path.join
  end


end
