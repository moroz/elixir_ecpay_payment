defmodule ECPayPayment.Hash do
  alias ECPayPayment.Config

  def calculate(params, profile_name, type) when is_map(params) do
    config = Config.get_config(profile_name, type)
    calculate(params, config)
  end

  def calculate(params, config) when is_map(params) do
    params
    |> encode_map_as_query(config)
    |> uri_escape()
    |> hash()
  end

  def verify(%{"CheckMacValue" => checksum} = params, config) do
    case calculate(params, config) == checksum do
      true ->
        :ok

      false ->
        {:error, :checksum}
    end
  end

  def verify(params, profile_name, type) do
    config = Config.get_config(profile_name, type)
    verify(params, config)
  end

  def verify(%{"MerchantID" => merchant_id} = payload) do
    config = Config.get_config_by_merchant_id(merchant_id)
    verify(payload, config)
  end

  def uri_escape(string) do
    string
    |> URI.encode_www_form()
    |> String.downcase()
    |> String.replace("%21", "!")
    |> String.replace("%2a", "*")
    |> String.replace("%28", "(")
    |> String.replace("%29", ")")
    |> String.replace("%20", "+")
    |> String.replace("%40", "%2540")
    |> String.replace("%257c", "%7c")
  end

  def hash_values(map, profile, type) do
    hash_key = Map.get(map, "HashKey", Config.get_hash_key(profile, type))
    hash_iv = Map.get(map, "HashIV", Config.get_hash_iv(profile, type))
    {hash_key, hash_iv}
  end

  def encode_pair({key, val}) do
    "#{key}=#{val}"
  end

  @forbidden ~w[CheckMacValue HashKey HashIV]

  @spec encode_map_as_query(map(), config :: map()) :: binary()
  def encode_map_as_query(map, %{hash_iv: hash_iv, hash_key: hash_key}) when is_map(map) do
    query_str =
      Enum.filter(map, fn {k, v} -> !is_nil(v) && to_string(k) not in @forbidden end)
      |> Enum.sort_by(fn {k, _v} -> String.downcase(to_string(k)) end)
      |> Enum.map(fn pair -> encode_pair(pair) end)
      |> Enum.join("&")

    "HashKey=#{hash_key}&" <> query_str <> "&HashIV=#{hash_iv}"
  end

  @spec encode_map_as_query(map(), profile :: atom(), type :: atom()) :: binary()
  def encode_map_as_query(map, profile_name, type) when is_map(map) do
    config = Config.get_config(profile_name, type)

    encode_map_as_query(map, config)
  end

  defp hash(value) do
    :crypto.hash(:sha256, value) |> Base.encode16(case: :upper)
  end
end
