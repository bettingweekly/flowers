# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateSingleDelivery do
  describe 'create' do
    before(:all) do
      Bouquet.create(FactoryGirl.attributes_for(:bouquet))
      Shipping.create(FactoryGirl.attributes_for(:shipping))
      @order = Order.create(FactoryGirl.attributes_for(:order))
      @order.update_attribute(:status, 'billed')
    end

    it 'should create a delivery object and update
        order status to complete' do
      subject = CreateSingleDelivery.new(@order)

      expect(Delivery.all.count).to eq 0
      expect(%w(failed billed).include?(@order.status)).to be_truthy

      subject.create

      expect(Delivery.all.count).to eq 1
      expect(%w(failed billed).include?(@order.status)).to be_falsey
      expect(@order.status).to eq 'complete'
    end
  end
end
