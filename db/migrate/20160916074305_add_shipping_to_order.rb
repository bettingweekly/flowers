# frozen_string_literal: true
class AddShippingToOrder < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    add_reference :orders, :shipping, foreign_key: true

    # update previous orders with default shipping_id
    default_shipping_id = Shipping.find_by_category('standard').id
    Order.update_all(shipping_id: default_shipping_id)
  end
end
