# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Shipping, type: :model do
  describe 'validation errors' do
    context 'presence' do
      it 'should error when category is missing' do
        subject.save
        expect(subject.errors[:category][0]).to be_nil
        subject.category = nil
        subject.save
        expect(subject.errors[:category][0]).to eq "can't be blank"
      end
    end

    context 'uniqueness' do
      it 'should not be valid if category is not unique' do
        Shipping.create(FactoryGirl.attributes_for(:shipping))
        shipping = Shipping.create(FactoryGirl.attributes_for(:shipping))
        expect(shipping.valid?).to be_falsey

        # with a unique name
        shipping_two = Shipping.create(category: 'special', charge: 2.50)
        expect(shipping_two.valid?).to be_truthy
      end
    end
  end
end
