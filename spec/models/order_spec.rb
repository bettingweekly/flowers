# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'default attributes' do
    it 'should have status set to pending' do
      expect(subject.status).to eq 'pending'
    end

    it 'should have three_month_bundle set to false' do
      expect(subject.three_month_bundle).to be_falsey
    end
  end

  describe 'validation errors' do
    context 'presence' do
      before(:each) { subject.save }
      it 'should error when recipient_name is missing' do
        expect(subject.errors[:recipient_name][0]).to eq "can't be blank"
        subject.recipient_name = 'Benjamin Button'
        subject.save
        expect(subject.errors[:recipient_name][0]).to be_nil
      end

      it 'should error when delivery_on is missing' do
        subject.delivery_on = nil
        subject.save
        expect(subject.errors[:delivery_on][0]).to eq "can't be blank"
        subject.delivery_on = Date.today
        subject.save
        expect(subject.errors[:delivery_on][0]).to be_nil
      end

      it 'should error when bouquet is missing' do
        expect(subject.errors[:bouquet][0]).to eq "can't be blank"
        subject.bouquet = Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        subject.save
        expect(subject.errors[:bouquet][0]).to be_nil
      end

      it 'should error when cost is missing' do
        Bouquet.create(name: 'Alice', price: 20)
        expect(subject.errors[:cost][0]).to eq "can't be blank"
        subject.bouquet_id = 1
        subject.save
        expect(subject.errors[:cost][0]).to be_nil
      end

      it 'should never have an error for status as it should never
          be missing on save or valid?' do
        expect(subject.errors[:status][0]).to be_nil
        subject.status = nil
        subject.save
        expect(subject.errors[:status][0]).to be_nil
      end

      it 'should error when shipping is missing' do
        expect(subject.errors[:shipping][0]).to eq "can't be blank"
        subject.shipping = Shipping.create(FactoryGirl.attributes_for(:shipping))
        subject.save
        expect(subject.errors[:shipping][0]).to be_nil
      end
    end

    context 'length' do
      it 'should not be valid if recipient_name is less than 1 char' do
        Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        Shipping.create(FactoryGirl.attributes_for(:shipping))
        subject.assign_attributes(FactoryGirl.attributes_for(:order))
        expect(subject.valid?).to be_truthy
        subject.recipient_name = ''
        expect(subject.valid?).to be_falsey
      end
    end

    context 'inclusion' do
      before(:each) do
        Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        Shipping.create(FactoryGirl.attributes_for(:shipping))
        subject.assign_attributes(FactoryGirl.attributes_for(:order))
      end

      it 'should not be valid if delivery_on is back dated' do
        expect(subject.valid?).to be_truthy
        subject.delivery_on = Date.today - 1.day
        expect(subject.valid?).to be_falsey
      end

      it 'should not be valid if delivery_on is over a year' do
        expect(subject.valid?).to be_truthy
        subject.delivery_on = Date.today + 2.years
        expect(subject.valid?).to be_falsey
      end
    end
  end

  describe 'before_validation' do
    before(:each) do
      subject.assign_attributes(FactoryGirl.attributes_for(:order))
    end

    context '#assign_cost' do
      it 'should assign cost' do
        Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        Shipping.create(FactoryGirl.attributes_for(:shipping))

        expect(subject.cost).to be_nil

        # .valid? runs the assign cost method
        # and updates the cost to be 20
        # making the subject valid
        expect(subject.valid?).to be_truthy
        expect(subject.cost).to eq 20
      end

      it 'should not assign cost if no bouquet exists' do
        # set bouquet_id to nil so no bouquet can be found
        subject.bouquet_id = nil
        expect(subject.cost).to be_nil

        expect(subject.valid?).to be_falsey
        expect(subject.cost).to be_nil
      end

      it 'should adjust the cost when a three month bundle' do
        Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        Shipping.create(FactoryGirl.attributes_for(:shipping))

        expect(subject.cost).to be_nil
        subject.three_month_bundle = true

        expect(subject.valid?).to be_truthy
        expect(subject.cost).to eq 56
      end
    end

    context '#determined_billed' do
      it 'should update the status of the order from pending to
          either (failed, billing)' do
        expect(subject.status).to eq 'pending'
        subject.valid?
        expect(%w(failed billed).include?(subject.status)).to be_truthy
      end
    end
  end

  describe 'calculating order cost' do
    before(:each) do
      subject.assign_attributes(FactoryGirl.attributes_for(:order))
      Bouquet.create(FactoryGirl.attributes_for(:bouquet))
      Shipping.create(FactoryGirl.attributes_for(:shipping))
    end

    it 'should set the cost to the price of the bouquet' do
      subject.valid?
      expect(subject.cost).to eq 20
    end

    it 'should set the cost to be the bouquet price * 3 with 10% of bouquet 2 and 3' do
      subject.three_month_bundle = true
      subject.valid?
      expect(subject.cost).to eq 56
    end
  end
end
