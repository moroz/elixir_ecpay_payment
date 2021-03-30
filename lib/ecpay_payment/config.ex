defmodule ECPayPayment.Config do
  @moduledoc """
  Convenience functions for working with ECPay credentials and configuration.
  """

  def default_profile, do: Application.get_env(:ecpay_payment, :default_profile)

  def get_all_config, do: Application.get_env(:ecpay_payment, :profiles)

  def get_config_by_merchant_id(merchant_id)
      when is_binary(merchant_id) or is_integer(merchant_id) do
    ECPayPayment.Config.get_all_config()
    |> Map.values()
    |> Enum.map(&Map.values/1)
    |> List.flatten()
    |> Enum.find(fn %{merchant_id: actual} -> to_string(actual) == to_string(merchant_id) end)
    |> case do
      map when is_map(map) ->
        map

      nil ->
        raise ArgumentError,
              "No payment configuration found for MerchantID #{merchant_id}."
    end
  end

  def get_config(profile_name \\ default_profile(), type \\ :single)

  def get_config(nil, type), do: get_config(default_profile(), type)

  def get_config(profile_name, type) when is_binary(profile_name) do
    get_config(String.to_atom(profile_name), type)
  end

  def get_config(profile_name, type) when is_atom(profile_name) and type in [:single, :multi] do
    all = get_all_config()

    case get_in(all, [profile_name, type]) do
      nil ->
        all_keys = Map.keys(all) |> Enum.join(", ")

        raise ArgumentError,
              "No payment configuration found for profile #{profile_name} and type #{type}. Available configuration profiles: #{
                all_keys
              }."

      config ->
        add_derived_config_properties(config)
    end
  end

  def add_derived_config_properties(%{development: true} = config) do
    Map.put(config, :host, "https://payment-stage.ecpay.com.tw")
  end

  def add_derived_config_properties(%{development: false} = config) do
    Map.put(config, :host, "https://payment.ecpay.com.tw")
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
