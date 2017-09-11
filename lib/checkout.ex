defmodule Checkout do

  def scan(cart, catalogue, sku) do
    case Map.has_key?(catalogue, sku) do
      true  -> {:ok, Map.update(cart, sku, 1, &(&1 + 1))}
      false -> {:error, "sku not found"}
    end
  end

  def total(cart, catalogue) do
    cart
    |> Enum.to_list
    |> Enum.reduce(0, fn {sku, quant}, sum ->
         sum + PricingRule.calculate_price(catalogue[sku], quant)
      end)
  end
end
