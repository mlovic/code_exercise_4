defprotocol PricingRule do
  def calculate_price(rule, quant)
end
