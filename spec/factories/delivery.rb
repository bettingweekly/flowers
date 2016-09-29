# frozen_string_literal: true
FactoryGirl.define do
  factory :delivery do
    bouquet_id 1
    username 'Guest'
    delivery_date Date.today
    order_id 1
  end
end
