defmodule ECPayPayment.Payload do
  alias ECPayPayment.Config
  alias ECPayPayment.Hash

  defprotocol Serializable do
    def to_map(data, config)

    def endpoint(config)
  end

  def serialize(payload, profile, type) do
    config = Config.get_config(profile, type)

    map = Serializable.to_map(payload, config)

    checksum = Hash.calculate(map, profile, type)

    Map.put(map, :CheckMacValue, checksum)
  end
end
