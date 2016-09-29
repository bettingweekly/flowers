# frozen_string_literal: true
class CreateThreeMonthBundleDelivery # :nodoc:
  attr_reader :order
  def initialize(order)
    @order = order
  end

  def create
    ActiveRecord::Base.transaction do
      deliveries = organised_bundle.map do |bouquet_id, delivery|
        Delivery.create!(
          bouquet_id: bouquet_id,
          username: 'guest'.capitalize,
          delivery_date: delivery,
          order_id: order.id
        )
      end
      order.update_attribute(:status, 'complete') if deliveries.all?(&:valid?)
    end
  end

  def organised_bundle
    bouquet_id = order.bouquet_id
    ordered_bouquets = order_bouquets(bouquet_id)

    start = order.delivery_on
    dates = [start, start + 1.month, start + 2.months]

    result = {}
    dates.each_with_index do |value, index|
      result[ordered_bouquets[index]] = value
    end
    result
  end

  def order_bouquets(num)
    arr = bouquets.map(&:id)
    arr.unshift(arr.slice!(num - 1, num)).flatten!
  end

  private

  def bouquets
    @bouquets ||= Bouquet.all.order(id: 'ASC')
  end
end
