# frozen_string_literal: true
class Shipping < ActiveRecord::Base # :nodoc:
  validates_presence_of :category, :charge
  validates_uniqueness_of :category
end
