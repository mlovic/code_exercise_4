Code.require_file "test/checkout_test_helper.exs"
defmodule CheckoutTest do
  use ExUnit.Case

  import CheckoutTest.Helper

  @catalogue %{
    "VOUCHER" => %PricingRules.BuyXGetOneFree{single_unit_price: 5, x: 2},
    "TSHIRT"  => %PricingRules.BulkDiscount{single_unit_price: 20.0, prices_by_min_order: [{3, 19.0}]},
    "MUG"     => %PricingRules.StandardPrice{single_unit_price: 7.5},
  }

  describe "scan" do
    test "adds item to cart when item is new" do
      cart = %{}
      {:ok, result} = Checkout.scan(cart, @catalogue, "VOUCHER")
      assert result == %{"VOUCHER" => 1}
    end

    test "increases item quantity when item is already in cart" do
      cart = %{"VOUCHER" => 1}
      {:ok, result} = Checkout.scan(cart, @catalogue, "VOUCHER")
      assert result == %{"VOUCHER" => 2}
    end

    test "returns error when invalid code is passed" do
      cart = %{}
      {status, _} = Checkout.scan(cart, @catalogue, "MISSING")
      assert status == :error
    end
  end

  describe "exercise examples" do
    test_cart_total(["VOUCHER", "TSHIRT", "MUG"], 32.5)
    test_cart_total(["VOUCHER", "TSHIRT", "VOUCHER"], 25.0)
    test_cart_total(["TSHIRT", "TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT"], 81.0)
    test_cart_total(["VOUCHER", "TSHIRT", "VOUCHER", "VOUCHER", "MUG","TSHIRT", "TSHIRT"], 74.5)
  end
end
