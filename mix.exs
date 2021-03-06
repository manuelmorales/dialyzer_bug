defmodule DialyzerBug.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dialyzer_bug,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      # dialyzer: [
      #   plt_add_deps: :transitive,
      #   paths: ["_build/dev/lib/dialyzer_bug/ebin", "_build/dev/lib/httpoison/ebin"]
      # ],
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
    ]
  end
end
