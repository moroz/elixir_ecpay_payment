defmodule ECPayPayment.Hash do
  alias ECPayPayment.Config

  def calculate(params, profile, type) when is_map(params) do
    params
    |> encode_map_as_query(profile, type)
    |> uri_escape()
    |> hash()
  end

  def verify(%{"CheckMacValue" => checksum} = params, profile, type) do
    case calculate(params, profile, type) == checksum do
      true ->
        :ok

      false ->
        {:error, :checksum}
    end
  end

  def uri_escape(string) do
    string
    |> URI.encode_www_form()
    |> String.downcase()
    |> String.replace("%21", "!")
    |> String.replace("%2a", "*")
    |> String.replace("%28", "(")
    |> String.replace("%29", ")")
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

  def forbidden_values do
    ~w[CheckMacValue HashKey HashIV]
  end

  @spec encode_map_as_query(map(), profile :: atom(), type :: atom()) :: binary()
  def encode_map_as_query(map, profile, type) when is_map(map) do
    {hash_key, hash_iv} = hash_values(map, profile, type)

    forbidden = forbidden_values()

    query_str =
      Enum.filter(map, fn {k, v} -> !is_nil(v) && to_string(k) not in forbidden end)
      |> Enum.map(fn pair -> encode_pair(pair) end)
      |> Enum.join("&")

    "HashKey=#{hash_key}&" <> query_str <> "&HashIV=#{hash_iv}"
  end

  defp hash(value) do
    :crypto.hash(:sha256, value) |> Base.encode16(case: :upper)
  end
end
