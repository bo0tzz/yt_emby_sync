defmodule YtEmbySync.MixProject do
  use Mix.Project

  def project do
    [
      app: :yt_emby_sync,
      version: "0.2.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {YtEmbySync.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:quantum, "~> 3.0"}
    ]
  end
end
