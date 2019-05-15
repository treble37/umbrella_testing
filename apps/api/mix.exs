defmodule Api.MixProject do
  use Mix.Project

  def project do
    [
      app: :api,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Api.Application, []},
      extra_applications: [:logger, :runtime_tools, :mnesia]
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
      {:phoenix, "~> 1.4.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:timber,
       git: "https://github.com/timberio/timber-elixir",
       ref: "ca9831b05b9c80d7c02a42c3dc8e63164cbba2f5"},
      {:timber_plug,
       git: "https://github.com/treble37/timber-elixir-plug.git",
       ref: "bf023fa6b1ad45c50582be61713559d2a0fdb5bf"},
      {:timber_phoenix,
       git: "https://github.com/treble37/timber-elixir-phoenix.git",
       ref: "4b12fd41128941422fcc2288ca85e694cecc7ab7"},
      {:timber_ecto,
       git: "https://github.com/treble37/timber-elixir-ecto.git",
       ref: "cb9b42dff52a382b42609fbb9d5ff9e21efc7ec6"},
      {:timber_exceptions,
       git: "https://github.com/treble37/timber-elixir-exceptions.git",
       ref: "a502bb120162e3cec5b4350f1966cf4b3ab2c006"},
      {:kv_server, in_umbrella: true}
    ]
  end
end
