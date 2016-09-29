# frozen_string_literal: true
module Validators
  class CheckDeliveryDate # :nodoc:
    attr_reader :due_delivery,
                :todays_date
    def initialize(due_delivery)
      @due_delivery = due_delivery
      @todays_date = DateTime.now
    end

    def validate
      # validate date with todays date against the delivery_ruleset table to check
      # that the delivery can in fact be made.
      # This could be used both before and after the client picks a date.
      # Before when they are provided the calendar
      # and after should you wish to use this class elsewhere
      true
    end
  end
end
