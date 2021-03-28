defmodule ECPayPayment.Config do
  @moduledoc """
  Convenience functions for working with ECPay credentials and configuration.
  """

  def default_profile, do: Application.get_env(:ecpay_payment, :default_profile)

  def get_all_config, do: Application.get_env(:ecpay_payment, :profiles)

  def get_config(profile_name \\ default_profile(), type \\ :single)

  def get_config(nil, type), do: get_config(default_profile(), type)

  def get_config(profile_name, type) when is_binary(profile_name) do
    get_config(String.to_atom(profile_name), type)
  end

  def get_config(profile_name, type) when is_atom(profile_name) and type in [:single, :multi] do
    all = get_all_config()

    case Map.fetch(all, profile_name) do
      {:ok, settings} ->
        case Map.get(settings, type) do
          %{development: true} = raw ->
            Map.put(raw, :host, "https://payment-stage.ecpay.com.tw")

          %{development: false} = raw ->
            Map.put(raw, :host, "https://payment.ecpay.com.tw")
        end

      _ ->
        all_keys = Map.keys(all) |> Enum.join(", ")

        raise ArgumentError,
              "No payment configuration found for profile #{profile_name}. Available configuration profiles: #{
                all_keys
              }."
    end
  end

  def get_hash_iv(profile_name, type), do: Map.get(get_config(profile_name, type), :hash_iv)
  def get_hash_key(profile_name, type), do: Map.get(get_config(profile_name, type), :hash_key)
  def development?(profile_name, type), do: Map.get(get_config(profile_name, type), :development)

  def get_merchant_id(profile_name, type),
    do: Map.get(get_config(profile_name, type), :merchant_id)

  def get_key_and_iv(profile, type) do
    {get_hash_key(profile, type), get_hash_iv(profile, type)}
  end
end
