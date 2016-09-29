# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'orders/new', type: :view do
  context 'Order form' do
    it 'should display the order form' do
      assign(:order, Order.new)
      assign(:bouquets, Bouquet.all)
      assign(:shipping, Shipping.all)

      render

      expect(rendered).to match(/Order your flowers/)
      expect(rendered).to match(/Recipient name/)
      expect(rendered).to match(/Delivery on/)
      expect(rendered).to match(/Check box if you would like to make this a three month bundle./)
      expect(rendered).to match(/Select your shipping/)
    end
  end
end
