defmodule Arrg.MixProject do
  use Mix.Project

  @version "1.1.0"

  def project do
    [
      app: :arrg,
      name: "Arrg",
      description: "Arrg is an Elixir media manager for movies, tv shows, and music",
      version: @version,
      elixir: "~> 1.14",
      source_url: "https://github.com/btkostner/arrg",
      homepage_url: "https://arrg.btkostner.io",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      test_coverage: [summary: [threshold: 0]],
      aliases: aliases(),
      deps: deps(),
      docs: docs()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Arrg.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bandit, ">= 0.7.3"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.21.0", only: [:dev, :test]},
      {:ecto_sql, "~> 3.6"},
      {:ecto_sqlite3, ">= 0.0.0"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:ex_heroicons, "~> 2.0.0"},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18.16"},
      {:phoenix, "~> 1.7.2"},
      {:plug_cowboy, "~> 2.5"},
      {:polymorphic_embed, "~> 3.0.5"},
      {:sobelow, "~> 0.11", only: [:dev, :test], runtime: false},
      {:tailwind_formatter, "~> 0.3.5", only: [:dev, :test], runtime: false},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end

  # Documentation is generated with ex_doc and published on new releases.
  # To generate new documentation, run:
  #
  #     $ mix docs
  #
  # You can then view them in `doc/index.html`, or use the published
  # version at https://arrg.btkostner.io.
  defp docs do
    [
      canonical: "https://arrg.btkostner.io",
      extras: [
        "README.md": [filename: "overview", title: "Overview"],
        "CHANGELOG.md": [filename: "changelog", title: "Changelog"]
      ],
      formatters: ["html", "epub"],
      main: "overview",
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"],
      source_ref: "main"
    ]
  end
end
