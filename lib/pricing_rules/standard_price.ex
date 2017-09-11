defmodule PricingRules.StandardPrice do
  @doc """
  Default pricing rule. No discount applied. 
  """
  defstruct [:single_unit_price]
end

defimpl PricingRule, for: PricingRules.StandardPrice do
  def calculate_price(rule, quant) do
    rule.single_unit_price * quant
  end
end
