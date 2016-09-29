# frozen_string_literal: true
class CreateOrder # :nodoc:
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def create
    if order.valid? && check_delivery_on_date
      order.save
      # Could create the Delivery Object at this point
      # Add it to a message queue to be processed when the server is
      # less busy
    else
      # Notify Bloom & wild of error (if needed)
      # Handle error to give the client a meaningful response
      # Can use the FindNextAvailableDate Model to suggest another date to the client.
      false
    end
  end

  def check_delivery_on_date
    Validators::CheckDeliveryDate.new(order.delivery_on).validate
    # Just returning true for example
    true
  end
end
