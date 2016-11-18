defmodule Elastex.Mixfile do
  use Mix.Project


  def project do
    [app: :elastex,
     name: "Elastex",
     source_url: "https://github.com/michaeldoaty/elastex",
     homepage_url: "https://github.com/michaeldoaty/elastex",
     version: "0.2.0",
     description: "Data driven elixir client for Elasticsearch.",
     package: package,
     elixir: "~> 1.3.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_paths: test_paths,
     deps: deps]
  end


  def application do
    [applications: [:logger, :httpoison]]
  end


  defp deps do
    [
      {:poison, "~> 2.0"},
      {:httpoison, "~> 0.8.0"},
      {:shouldi, ">= 0.0.0", only: :test},
      {:mix_test_watch, "~> 0.2.6", only: :dev},
      {:ex_doc, "~> 0.12", only: :dev},
      {:dialyxir, "~> 0.4", only: :dev}
    ]
  end


  defp package do
    [
      maintainers: ["Michael Doaty"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/michaeldoaty/elastex"}
    ]
  end

  defp test_paths do
    ["test", "integration_test"]
  end

end
