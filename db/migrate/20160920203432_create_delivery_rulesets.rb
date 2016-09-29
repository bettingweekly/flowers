# frozen_string_literal: true
class CreateDeliveryRulesets < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    royal_mail_id = Courier.find_by_name('royal_mail')

    create_table :delivery_rulesets do |t|
      t.references :courier, foreign_key: true, required: true, default: royal_mail_id
      t.string :day, required: true
      t.string :start_time, required: true
      t.string :cutoff_time, required: true

      t.timestamps null: false
    end

    populate_rulesets
  end

  def populate_rulesets
    rm_id = Courier.find_by_name('royal_mail')
    dpd_id = Courier.find_by_name('dpd')

    # Dumby rulesets
    rulesets = [{ courier_id: rm_id, day: 'monday', start_time: '06:00', cutoff_time: '15:30' },
                { courier_id: rm_id, day: 'tuesday', start_time: '08:00', cutoff_time: '12:30' },
                { courier_id: rm_id, day: 'wednesday', start_time: '09:00', cutoff_time: '15:30' },
                { courier_id: rm_id, day: 'thursday', start_time: '05:00', cutoff_time: '16:30' },
                { courier_id: rm_id, day: 'friday', start_time: '06:00', cutoff_time: '15:30' },
                { courier_id: rm_id, day: 'saturday', start_time: '06:00', cutoff_time: '13:30' },
                { courier_id: dpd_id, day: 'monday', start_time: '09:00', cutoff_time: '18:00' },
                { courier_id: dpd_id, day: 'tuesday', start_time: '10:00', cutoff_time: '17:00' },
                { courier_id: dpd_id, day: 'wednesday', start_time: '06:00', cutoff_time: '15:30' },
                { courier_id: dpd_id, day: 'friday', start_time: '06:00', cutoff_time: '15:30' },
                { courier_id: dpd_id, day: 'saturday', start_time: '06:00', cutoff_time: '15:30' }]

    rulesets.each do |r|
      DeliveryRuleset.create!(b) unless DeliveryRuleset.where(day: r[:day],
                                                              start_time: r[:start_time],
                                                              cutoff_time: r[:cutoff_time])
    end
  end
end
