# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CreateThreeMonthBundleDelivery do
  before(:all) do
    bouquets = [{ name: 'Alice', price: 20 },
                { name: 'Charlotte', price: 22.5 },
                { name: 'Isabel', price: 30 }]

    bouquets.each do |b|
      Bouquet.create!(b) unless Bouquet.find_by_name(b[:name])
    end

    Shipping.create(FactoryGirl.attributes_for(:shipping))
    @order = Order.create(FactoryGirl.attributes_for(:order))
    @order.update_attribute(:status, 'billed')
  end

  it 'should create 3 delivery objects and update the
      order status to complete after all 3 have been created' do
    subject = CreateThreeMonthBundleDelivery.new(@order)

    expect(Delivery.all.count).to eq 0
    expect(%w(failed billed).include?(@order.status)).to be_truthy

    subject.create

    expect(Delivery.all.count).to eq 3
    expect(%w(failed billed).include?(@order.status)).to be_falsey
    expect(@order.status).to eq 'complete'
  end

  describe 'order_bouquets' do
    before(:each) { @subject = CreateThreeMonthBundleDelivery.new(@order) }

    context 'bouquet ID is number 1' do
      it 'should return array [1,2,3]' do
        expect(@subject.order_bouquets(1)).to eq [1, 2, 3]
      end
    end

    context 'bouquet ID is number 2' do
      it 'should return array [2,3,1]' do
        expect(@subject.order_bouquets(2)).to eq [2, 3, 1]
      end
    end

    context 'bouquet ID is number 3' do
      it 'should return array [3,1,2]' do
        expect(@subject.order_bouquets(3)).to eq [3, 1, 2]
      end
    end
  end
end
