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
      default_profile: :staging
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:timex, "~> 3.7"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"}
    ]
  end
end
