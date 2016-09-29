# frozen_string_literal: true
class CreateDeliveries # :nodoc:
  class << self
    def execute(date)
      Order.where(delivery_on: date)
           .in_batches(of: 1000) do |orders|
        create_deliveries(orders)
      end
    end

    def create_deliveries(orders)
      orders.each do |order|
        next unless order.status == 'billed'
        if order.three_month_bundle
          CreateThreeMonthBundleDelivery.new(order).create
        else
          next if Delivery.find_by_order_id(order.id)
          CreateSingleDelivery.new(order).create
        end
      end
    end
  end
end
