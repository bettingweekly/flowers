# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Bouquet, type: :model do
  describe 'validation errors' do
    context 'presence' do
      before(:each) { subject.save }
      it 'should error when name is missing' do
        expect(subject.errors[:name][0]).to eq "can't be blank"
        subject.name = 'Alice'
        subject.save
        expect(subject.errors[:name][0]).to be_nil
      end

      it 'should error when price is missing' do
        expect(subject.errors[:price][0]).to eq "can't be blank"
        subject.price = 20
        subject.save
        expect(subject.errors[:price][0]).to be_nil
      end
    end

    context 'uniqueness' do
      # bouquets with the same name and different price
      # would cause confusion to the client
      it 'should not be valid if bouquet name is not unique' do
        Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        bouquet = Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        expect(bouquet.valid?).to be_falsey

        # with a unique name
        bouquet_two = Bouquet.create(name: 'In-Wonderland', price: 20)
        expect(bouquet_two.valid?).to be_truthy
      end
    end

    context 'length' do
      it 'should not be valid if bouquet name is less than 2 chars' do
        subject.assign_attributes(name: 'A', price: 20)
        expect(subject.valid?).to be_falsey
        subject.name = 'Al'
        expect(subject.valid?).to be_truthy
      end
    end

    context 'numericality' do
      before(:each) do
        subject.assign_attributes(FactoryGirl.attributes_for(:bouquet))
      end

      it 'should not be valid if price is negative' do
        subject.price = -1
        expect(subject.valid?).to be_falsey
        subject.price = 1
        expect(subject.valid?).to be_truthy
      end

      it 'should be valid if price is greater_than_or_equal_to ZERO' do
        subject.price = 0
        expect(subject.valid?).to be_truthy
        subject.price = 10
        expect(subject.valid?).to be_truthy
      end

      it 'should not be valid if price is not less_than_or_equal_to 10_000' do
        subject.price = 10_001
        expect(subject.valid?).to be_falsey
        subject.price = 10_000
        expect(subject.valid?).to be_truthy
      end

      it 'should not allow non-numeric characters' do
        subject.price = 'twenty'
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
