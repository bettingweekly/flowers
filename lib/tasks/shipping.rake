# frozen_string_literal: true
namespace :shipping do
  desc 'Creates delivery objects from orders for a given date.'
  task :deliveries, [:date] => :environment do |_, args|
    CreateDeliveries.execute(args.date)
  end
end
