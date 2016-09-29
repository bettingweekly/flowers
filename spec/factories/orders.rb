# frozen_string_literal: true
FactoryGirl.define do
  factory :order do
    recipient_name 'Benjamin Fowl'
    bouquet_id 1
    delivery_on Date.today
    status 'pending'
    cost nil
    shipping_id 1
    three_month_bundle false
  end
end
