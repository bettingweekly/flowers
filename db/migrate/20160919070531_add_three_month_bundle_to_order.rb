# frozen_string_literal: true
class AddThreeMonthBundleToOrder < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    add_column :orders, :three_month_bundle, :boolean, default: false
  end
end
