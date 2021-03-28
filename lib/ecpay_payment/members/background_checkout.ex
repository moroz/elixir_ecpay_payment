defmodule ECPayPayment.Members.BackgroundCheckout do
  defstruct([
    :customer_id,
    :description,
    :merchant_trade_no,
    :merchant_trade_date,
    :total_amount,
    :trade_desc,
    :card_id
  ])

  defimpl ECPayPayment.Payload.Serializable do
    def endpoint(config) do
      "#{config.host}/MerchantMember/AuthCardID/V2"
    end

    defp format_timestamp(time) do
      (time || Timex.now())
      |> Timex.Timezone.convert("Asia/Taipei")
      |> Timex.format!("%Y/%m/%d %H:%M:%S", :strftime)
    end

    def to_map(data, %{merchant_id: merchant_id}) do
      %{
        MerchantID: merchant_id,
        MerchantMemberID: "#{merchant_id}#{data.customer_id}",
        MerchantTradeNo: data.merchant_trade_no,
        MerchantTradeDate: format_timestamp(data.merchant_trade_date),
        TotalAmount: floor(data.total_amount),
        TradeDesc: data.description,
        CardID: data.card_id,
        stage: 0
      }
    end
  end
end
