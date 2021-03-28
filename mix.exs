defmodule EcpayPayment.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecpay_payment,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto],
      env: defaults()
    ]
  end

  defp defaults do
    [
      profiles: %{
        staging: %{
          single: %{
            merchant_id: "2000132",
            hash_key: "5294y06JbISpM5x9",
            hash_iv: "v77hoKGq4kWxNNIS",
            development: true
          },
          multi: %{
            merchant_id: "2000214",
            hash_key: "5294y06JbISpM5x9",
            hash_iv: "v77hoKGq4kWxNNIS",
            development: true
          }
        }
      },
      default_profile: :staging,
      send_notifications: true
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end