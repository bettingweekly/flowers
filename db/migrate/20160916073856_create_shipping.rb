# frozen_string_literal: true
class CreateShipping < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :shippings do |t|
      t.string :category, default: 'standard', required: true
      t.float :charge, default: 0, required: true

      t.timestamps null: false
    end

    shipping = [{ category: 'standard', charge: 0 },
                { category: 'special', charge: 2.50 }]

    shipping.each do |s|
      Shipping.create!(s) unless Shipping.find_by_category(s[:type])
    end
  end
end
