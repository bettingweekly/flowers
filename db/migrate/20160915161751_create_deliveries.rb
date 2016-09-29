# frozen_string_literal: true
class CreateDeliveries < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :deliveries do |t|
      t.references :bouquet, required: true, foreign_key: true
      t.string :username, required: true
      t.date :delivery_date, required: true
      t.references :order, required: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
