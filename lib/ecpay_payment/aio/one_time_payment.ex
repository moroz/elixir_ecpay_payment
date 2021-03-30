defmodule ECPayPayment.AIO.OneTimePayment do
  alias ECPayPayment.Timestamps

  defstruct merchant_trade_no: nil,
            timestamp: nil,
            amount: 1,
            description: nil,
            return_url: nil,
            finish_url: nil,
            items: [],
            payment: "ALL",
            language: nil

  defimpl ECPayPayment.Payload.Serializable do
    def endpoint(_data) do
      "/Cashier/AioCheckOut/V5"
    end

    def to_map(data, %{merchant_id: merchant_id}) do
      %{
        "ClientBackURL" => data.finish_url || "",
        "ChoosePayment" => data.payment,
        "EncryptType" => 1,
        "MerchantID" => merchant_id,
        "MerchantTradeNo" => data.merchant_trade_no,
        "MerchantTradeDate" => Timestamps.format_timestamp(data.timestamp),
        "NeedExtraPaidInfo" => "Y",
        "PaymentType" => "aio",
        "TotalAmount" => data.amount,
        "TradeDesc" => data.description,
        "ItemName" => Enum.join(data.items, "#"),
        "ReturnURL" => data.return_url
      }
    end
  end
end
