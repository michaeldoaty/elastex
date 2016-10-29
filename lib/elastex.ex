defmodule Elastex.Builder do
  defstruct [:url, :body, :method, :action, :params, :index, :type, :id, :options, :headers]

  @type int_or_string :: non_neg_integer | String.t
  @type body          :: map | struct | nil

  @type t :: %__MODULE__{
    url:     String.t,
    body:    body,
    method:  atom,
    action:  atom,
    params:  Keyword.t,
    index:   String.t | nil,
    type:    String.t | nil,
    id:      int_or_string | nil,
    options: map,
    headers: Keyword.t
  }
end


defmodule Elastex do
  alias Elastex.Helper
  alias Elastex.Web

  def run(req, conn) do
    Helper.build(req, conn) |> Web.http_call
  end

end


defmodule Elastex.Builder.Extender do
  alias Elastex.Builder

  @callback params(Builder.t, Keyword.t) :: Builder.t
end
