defmodule CheckoutTest.Helper do
  import ExUnit.Assertions, only: [flunk: 1]

  def bulk_scan(initial_cart, catalogue, skus) do
    Enum.reduce skus, initial_cart, fn sku, cart ->
      case Checkout.scan(cart, catalogue, sku) do
        {:ok, new} -> new
        {:error, err} -> flunk(err)
      end
    end
  end

  defmacro test_cart_total(skus, total) do
    quote do
      test unquote(Enum.join(skus, ", ")) do
        # TODO catalogue okay quoted?
        cart = bulk_scan(%{}, @catalogue, unquote(skus))
        assert Checkout.total(cart, @catalogue) == unquote(total)
      end
    end
  end
end
