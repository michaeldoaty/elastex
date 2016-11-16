# Elastex

  Data driven elixir client for Elasticsearch.


## Get Started
1. Add this to your mix.exs file

  ```elixir
  {:elastex, "~> 0.2.0"}
  ```

2.  Add config setup in the appropriate config file for your environment i.e. `config/dev.exs`

  ```elixir
  config :elastex, url: "http://localhost:9200"
  ```
  
3.  Enjoy! (documentation is located here ...TODO add link)  


## Data driven?
Elastex has two functions that perform side effects `Elastex.run/1` and `Elastex.run/2`

All other functions in Elastex return or operate on `%Elastex.Builder{}`

For example `Elastex.Search.query` returns a builder

```elixir
iex> Elastex.Search.query
%Elastex.Builder{
  url: "_search",
  method: :post,
  action: :search_query
}
```

Elasticsearch allows searching through params so we can update our initial query by updating the builder.  
Adding params for search queries can be added by `Elastex.Search.params/1`


```elixir
iex> Elastex.Search.query |> Elastex.Search.params([q: "user:mike"])
%Elastex.Builder{
  url: "_search",
  method: :post,
  action: :search_query,
  params: [q: "user:mike"]
}
```

Operating on the builders (data) instead of having each function make a HTTP request allows for easier manipulation and testing.

A great example of working with data is `Elastex.Search.multi_search/1`

```elixir
      iex> query_builders = [
      ...> Elastex.Search.query(%{hello: "world"}),
      ...> Elastex.Search.query(%{hello: "world"}, "twitter", "tweet")
      ...> ]
      iex> Elastex.Search.multi_search(query_builders)
      %Elastex.Builder {
        url: "_msearch",
        body: "...",
        method: :post,
        action: :multi_search
      }
```

Here bulk takes normal `Elastex.Search.query` functions and uses them as input for the multi search.  This same technique is used for `Elastex.Document.bulk`.

## Examples

```elixir

# search example
%{query: %{term: %{user: "mike"}}}
|> Elastex.Search.query()
|> Elastex.run

# document example
Elastex.Document.index("twitter", "tweet", 1) |> Elastex.run

# index example
Elastex.Index.create("twitter") |> Elastex.run

# cluster example
Cluster.health("twitter") |> Elastex.run
```
