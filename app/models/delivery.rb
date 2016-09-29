# frozen_string_literal: true
class Delivery < ActiveRecord::Base # :nodoc:
  belongs_to :order
  belongs_to :bouquet

  validates_presence_of :bouquet,
                        :username,
                        :delivery_date,
                        :order

  validates :delivery_date, inclusion: { in: (Date.today..Date.today + 1.year) }
end
