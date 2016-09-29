# frozen_string_literal: true
class CreateSingleDelivery # :nodoc:
  attr_reader :order
  def initialize(order)
    @order = order
  end

  def create
    delivery = Delivery.create(
      bouquet_id: order.bouquet_id,
      username: 'guest'.capitalize,
      delivery_date: order.delivery_on,
      order_id: order.id
    )
    order.update_attribute(:status, 'complete') if delivery.valid?
  end
end
