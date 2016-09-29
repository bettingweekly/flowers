# frozen_string_literal: true
class Order < ActiveRecord::Base # :nodoc:
  belongs_to :bouquet
  belongs_to :shipping

  validates_presence_of :recipient_name,
                        :delivery_on,
                        :bouquet,
                        :cost,
                        :status,
                        :shipping

  validates_length_of :recipient_name, minimum: 1
  validates :delivery_on, inclusion: { in: (Date.today..Date.today + 1.year) }

  before_validation :assign_cost, :determined_billed

  def assign_cost
    calculate_cost if bouquet
  end

  # This is a method that fakes a 10% failure rate on billing
  def determined_billed
    self.status = if Random.rand(10) == 1
                    'failed'
                  else
                    'billed'
                  end
  end

  private

  def calculate_cost
    ten_percent_off = bouquet.price - bouquet.price / 100 * 10
    self.cost = if three_month_bundle
                  (bouquet.price + ten_percent_off * 2).round(2)
                else
                  bouquet.price.round(2)
                end
  end
end
