# frozen_string_literal: true
class CreateCouriers < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :couriers do |t|
      t.string :name, required: true

      t.timestamps null: false
    end

    populate_couriers
  end

  def populate_couriers
    couriers = [{ name: 'royal_mail' },
                { name: 'dpd' }]

    couriers.each do |b|
      Courier.create!(b) unless Courier.find_by_name(b[:name])
    end
  end
end
