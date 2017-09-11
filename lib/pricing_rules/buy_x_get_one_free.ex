defmodule PricingRules.BuyXGetOneFree do
  @doc """
  For each X units ordered, one will be free of charge
  """
  defstruct single_unit_price: nil, x: {}
end

defimpl PricingRule, for: PricingRules.BuyXGetOneFree do
  def calculate_price(rule, quant) do
    quant_for_free = Integer.floor_div(quant, rule.x)
    (quant - quant_for_free ) * rule.single_unit_price
  end
end
