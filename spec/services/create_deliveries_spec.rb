# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateDeliveries do
  describe 'execute' do
    before(:each) do
      Bouquet.create(FactoryGirl.attributes_for(:bouquet))
      Shipping.create(FactoryGirl.attributes_for(:shipping))
      @order = Order.create(FactoryGirl.attributes_for(:order))
      @order.update_attribute(:status, 'billed')
    end

    context 'order is not in state of billed so should be skipped' do
      it 'should not create a new delivery' do
        @order.update_attribute(:status, 'complete')
        expect(Delivery.all.count).to eq 0

        CreateDeliveries.execute(Date.today)

        expect(Delivery.all.count).to eq 0
      end
    end

    context 'Delivery already exists' do
      it 'should not create a new delivery' do
        expect(Delivery.all.count).to eq 0
        CreateSingleDelivery.new(@order).create
        expect(Delivery.all.count).to eq 1
        Order.first.update_attribute(:status, 'billed')
        CreateDeliveries.execute(Date.today)
        expect(Delivery.all.count).to eq 1
      end
    end

    context 'Delivery does not exist and order is in billed state' do
      it 'should create a new delivery' do
        expect(Delivery.all.count).to eq 0
        CreateDeliveries.execute(Date.today)
        expect(Delivery.all.count).to eq 1
      end
    end
  end
end
