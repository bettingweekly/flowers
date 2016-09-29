# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Delivery, type: :model do
  describe 'validation errors' do
    context 'presence' do
      before(:each) { subject.save }
      it 'should error when bouquet is missing' do
        expect(subject.errors[:bouquet][0]).to eq "can't be blank"
        subject.bouquet = Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        subject.save
        expect(subject.errors[:bouquet][0]).to be_nil
      end

      it 'should error when username is missing' do
        expect(subject.errors[:username][0]).to eq "can't be blank"
        subject.username = 'Alice'
        subject.save
        expect(subject.errors[:username][0]).to be_nil
      end

      it 'should error when delivery_date is missing' do
        expect(subject.errors[:delivery_date][0]).to eq "can't be blank"
        subject.delivery_date = Date.today
        subject.save
        expect(subject.errors[:delivery_date][0]).to be_nil
      end

      it 'should error when order is missing' do
        expect(subject.errors[:order][0]).to eq "can't be blank"
        subject.order = Order.new(FactoryGirl.attributes_for(:order))
        subject.save
        expect(subject.errors[:order][0]).to be_nil
      end
    end

    context 'inclusion' do
      before(:each) do
        Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        Shipping.create(FactoryGirl.attributes_for(:shipping))
        Order.create(FactoryGirl.attributes_for(:order))
        subject.assign_attributes(FactoryGirl.attributes_for(:delivery))
      end

      it 'should not be valid if delivery_date is back dated' do
        expect(subject.valid?).to be_truthy
        subject.delivery_date = Date.today - 1.day
        expect(subject.valid?).to be_falsey
      end

      it 'should not be valid if delivery_date is a over a year' do
        expect(subject.valid?).to be_truthy
        subject.delivery_date = Date.today + 2.years
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
