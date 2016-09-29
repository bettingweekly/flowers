# frozen_string_literal: true
class OrdersController < ApplicationController # :nodoc:
  def new
    @order = Order.new
    @bouquets = Bouquet.all
    @shipping = Shipping.all
  end

  def create
    order = Order.new order_params

    if CreateOrder.new(order).create
      redirect_to root_path, notice: 'Order saved'
    else
      redirect_back fallback_location: root_path,
                    alert: 'There was a problem with your order'
    end
  end

  private

  def order_params
    params.require(:order).permit(:recipient_name,
                                  :bouquet_id,
                                  :delivery_on,
                                  :shipping_id,
                                  :three_month_bundle)
  end
end
