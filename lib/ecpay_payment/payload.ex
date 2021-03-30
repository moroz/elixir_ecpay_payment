defmodule ECPayPayment.Payload do
  alias ECPayPayment.Config
  alias ECPayPayment.Hash

  defprotocol Serializable do
    def to_map(data, config)

    def endpoint(data)
  end

  def get_endpoint(payload, profile_name, type) do
    config = Config.get_config(profile_name, type)
    get_endpoint(payload, config)
  end

  def get_endpoint(payload, config) do
    config.host <> Serializable.endpoint(payload)
  end

  def to_map(payload, profile_name, type) do
    config = Config.get_config(profile_name, type)
    to_map(payload, config)
  end

  def to_map(payload, config) do
    map = Serializable.to_map(payload, config)
    Map.put(map, "CheckMacValue", Hash.calculate(map, config))
  end

  def to_www_form(payload, profile_name, type) do
    config = Config.get_config(profile_name, type)
    to_www_form(payload, config)
  end

  def to_www_form(payload, config) do
    map = Serializable.to_map(payload, config)
    checksum = Hash.calculate(map, config)

    sorted = Enum.sort_by(map, fn {key, _val} -> String.downcase(to_string(key)) end)

    data =
      for {key, val} <- sorted do
        "#{key}=#{URI.encode(to_string(val))}&"
      end

    [data, "CheckMacValue=#{checksum}"]
  end
end
