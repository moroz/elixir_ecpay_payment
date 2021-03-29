defmodule ECPayPayment.Timestamps do
  def parse_ecpay_timestamp(timestamp) do
    Timex.parse!(timestamp, "%Y/%m/%d %H:%M:%S", :strftime)
    |> DateTime.from_naive!("Asia/Taipei")
  end

  def format_timestamp(time \\ Timex.now()) do
    time
    |> Timex.Timezone.convert("Asia/Taipei")
    |> Timex.format!("%Y/%m/%d %H:%M:%S", :strftime)
  end
end
