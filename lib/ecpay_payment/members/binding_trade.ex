defmodule ECPayPayment.Members.BindingTrade do
  defstruct merchant_trade_no: nil,
            aio_trade_no: nil,
            customer_id: nil

  defimpl ECPayPayment.Payload.Serializable do
    def endpoint(_data) do
      "/MerchantMember/BindingTrade"
    end

    def to_map(data, %{merchant_id: merchant_id}) do
      %{
        MerchantID: merchant_id,
        MerchantMemberID: "#{merchant_id}#{data.customer_id}",
        MerchantTradeNo: data.merchant_trade_no,
        AllpayTradeNo: data.aio_trade_no
      }
    end
  end
end
