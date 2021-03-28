defmodule ECPayPayment.HashTest do
  use ExUnit.Case
  alias ECPayPayment.Hash

  @source_map %{
    "ChoosePayment" => "ALL",
    "EncryptType" => "1",
    "HashIV" => "v77hoKGq4kWxNNIS",
    "HashKey" => "5294y06JbISpM5x9",
    "ItemName" => "Apple iphone 7 手機殼",
    "MerchantID" => "2000132",
    "MerchantTradeDate" => "2013/03/12 15:30:23",
    "MerchantTradeNo" => "ecpay20130312153023",
    "PaymentType" => "aio",
    "ReturnURL" => "https://www.ecpay.com.tw/receive.php",
    "TotalAmount" => "1000",
    "TradeDesc" => "促銷方案"
  }

  @query_string "HashKey=5294y06JbISpM5x9&ChoosePayment=ALL&EncryptType=1&ItemName=Apple iphone 7 手機殼&MerchantID=2000132&MerchantTradeDate=2013/03/12 15:30:23&MerchantTradeNo=ecpay20130312153023&PaymentType=aio&ReturnURL=https://www.ecpay.com.tw/receive.php&TotalAmount=1000&TradeDesc=促銷方案&HashIV=v77hoKGq4kWxNNIS"

  @query_escaped "hashkey%3d5294y06jbispm5x9%26choosepayment%3dall%26encrypttype%3d1%26itemname%3dapple+iphone+7+%e6%89%8b%e6%a9%9f%e6%ae%bc%26merchantid%3d2000132%26merchanttradedate%3d2013%2f03%2f12+15%3a30%3a23%26merchanttradeno%3decpay20130312153023%26paymenttype%3daio%26returnurl%3dhttps%3a%2f%2fwww.ecpay.com.tw%2freceive.php%26totalamount%3d1000%26tradedesc%3d%e4%bf%83%e9%8a%b7%e6%96%b9%e6%a1%88%26hashiv%3dv77hokgq4kwxnnis"

  @sha256_hash "CFA9BDE377361FBDD8F160274930E815D1A8A2E3E80CE7D404C45FC9A0A1E407"

  test "encode_map_as_query/1 returns proper query string" do
    assert Hash.encode_map_as_query(@source_map, nil, :single) == @query_string
  end

  test "uri_escape/1 returns query-encoded params" do
    assert Hash.uri_escape(@query_string) == @query_escaped
  end

  test "encode_map_as_query + uri_escape returns correct string" do
    actual =
      Hash.encode_map_as_query(@source_map, nil, :single)
      |> Hash.uri_escape()

    assert actual == @query_escaped
  end

  test "calculate/1 returns correct SHA256 hash" do
    assert Hash.calculate(@source_map, nil, :single) == @sha256_hash
  end
end
