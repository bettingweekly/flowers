# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'GET new' do
    it 'should content_type text/html and have a success status' do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'text/html'
    end

    it 'should render template :new' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST create' do
    context 'with valid order' do
      before(:each) do
        Bouquet.create(FactoryGirl.attributes_for(:bouquet))
        Shipping.create(FactoryGirl.attributes_for(:shipping))
        @order_params = FactoryGirl.attributes_for(:order)
      end

      it 'should create a new order' do
        expect do
          post :create, params: { order: @order_params }
        end.to change(Order, :count).by(1)
      end

      it 'should render root_path and display success message' do
        post :create, params: { order: @order_params }

        expect(flash[:notice]).to eq('Order saved')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid order' do
      before(:each) { @order_params = FactoryGirl.attributes_for(:order) }

      it 'should not create a new order' do
        # No bouquet exists causing the order to be invalid
        expect do
          post :create, params: { order: @order_params }
        end.to change(Order, :count).by(0)
      end

      it 'should render root_path and display error message' do
        post :create, params: { order: @order_params }

        expect(flash[:alert]).to eq('There was a problem with your order')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
