# frozen_string_literal: true
class Bouquet < ActiveRecord::Base # :nodoc:
  validates_presence_of :name, :price
  validates_uniqueness_of :name
  validates_length_of :name, minimum: 2
  validates_numericality_of :price,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 10_000
end
