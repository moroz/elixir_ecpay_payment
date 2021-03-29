defmodule ECPayPayment.Request do
  alias ECPayPayment.Payload
  alias ECPayPayment.Config

  def post(payload, profile_name, type) do
    config = Config.get_config(profile_name, type)
    body = Payload.serialize(payload, config)
    endpoint = Payload.get_endpoint(payload, config)

    HTTPoison.post!(endpoint, body, [
      {"content-type", "application/x-www-form-urlencoded"}
    ])
  end
end
