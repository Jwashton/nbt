defmodule NBT.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nbt,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.8.10", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.18.1", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.5.0", only: [:dev], runtime: false}
    ]
  end
end
