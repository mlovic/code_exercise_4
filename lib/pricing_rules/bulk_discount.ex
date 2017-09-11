defmodule PricingRules.BulkDiscount do
  @doc """
  Different price depending on the quantity ordered

  * :prices_by_min_order - list of tuples, each describing the minimum order 
    quantity (first value) to receive a certain price (second value)
  """
  defstruct single_unit_price: nil, prices_by_min_order: {}
end

defimpl PricingRule, for: PricingRules.BulkDiscount do
  def calculate_price(rule, quant) do
    [{0, rule.single_unit_price} | rule.prices_by_min_order]
    |> sort_by_descending_min_order()
    |> Enum.find(fn {min_order, _} -> quant >= min_order end)
    |> elem(1) # get price
    |> Kernel.*(quant) 
  end

  defp sort_by_descending_min_order(prices_by_min_order) do
    Enum.sort prices_by_min_order, fn {min_order_a, _}, {min_order_b, _} ->
      min_order_a >= min_order_b
    end
  end
end
