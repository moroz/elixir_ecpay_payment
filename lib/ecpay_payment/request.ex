defmodule ECPayPayment.Request do
  alias ECPayPayment.Payload
  alias ECPayPayment.Hash
  alias ECPayPayment.Config

  def post(payload, profile_name, type) do
    config = Config.get_config(profile_name, type)
    body = Payload.serialize(payload, config)
    endpoint = Payload.get_endpoint(payload, config)

    res =
      HTTPoison.post!(endpoint, body, [
        {"content-type", "application/x-www-form-urlencoded"}
      ])

    process_response(res, config)
  end

  def process_response(%HTTPoison.Response{status_code: 200, body: body}, config) do
    payload = URI.decode_query(body)

    with :ok <- Hash.verify(payload, config) do
      case payload do
        %{"RtnCode" => "1"} ->
          {:ok, payload}

        _ ->
          {:error, payload}
      end
    end
  end

  def process_response(%HTTPoison.Response{status_code: _}, _) do
    {:error, :request_failed}
  end
end
