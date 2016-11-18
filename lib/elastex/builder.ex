defmodule Elastex.Builder do
  @moduledoc """
   This module contains Elastex.Builder
  """
  
  defstruct [:url, :body, :method, :action, :params, :index, :type, :id, :options, :headers]


  @type int_or_string :: non_neg_integer | String.t
  @type body          :: map() | nil


  @type t :: %__MODULE__{
    url:     String.t,
    body:    body,
    method:  atom,
    action:  atom,
    params:  Keyword.t,
    index:   String.t | nil,
    type:    String.t | nil,
    id:      int_or_string | nil,
    options: map(),
    headers: Keyword.t
  }
end
