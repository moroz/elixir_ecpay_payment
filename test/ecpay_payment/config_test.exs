defmodule ECPayPayment.ConfigTest do
  use ExUnit.Case
  alias ECPayPayment.Config

  describe "get_config_by_merchant_id/1" do
    test "returns correct config by int when a config with the given merchant_id exists" do
      actual = Config.get_config_by_merchant_id(2_000_132)
      assert actual.merchant_id == to_string(2_000_132)
    end

    test "returns correct config by string when a config with the given merchant_id exists" do
      actual = Config.get_config_by_merchant_id("2000132")
      assert actual.merchant_id == "2000132"
    end
  end
end
