# frozen_string_literal: true
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_160_920_203_432) do
  create_table 'bouquets', force: :cascade do |t|
    t.string   'name'
    t.float    'price'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'couriers', force: :cascade do |t|
    t.string   'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'deliveries', force: :cascade do |t|
    t.integer  'bouquet_id'
    t.string   'username'
    t.date     'delivery_date'
    t.integer  'order_id'
    t.datetime 'created_at',    null: false
    t.datetime 'updated_at',    null: false
    t.index ['bouquet_id'], name: 'index_deliveries_on_bouquet_id'
    t.index ['order_id'], name: 'index_deliveries_on_order_id'
  end

  create_table 'delivery_rulesets', force: :cascade do |t|
    t.integer  'courier_id'
    t.string   'day'
    t.string   'start_time'
    t.string   'cutoff_time'
    t.datetime 'created_at',  null: false
    t.datetime 'updated_at',  null: false
    t.index ['courier_id'], name: 'index_delivery_rulesets_on_courier_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.string   'recipient_name'
    t.integer  'bouquet_id'
    t.date     'delivery_on'
    t.string   'status', default: 'pending'
    t.float    'cost'
    t.datetime 'created_at',                             null: false
    t.datetime 'updated_at',                             null: false
    t.integer  'shipping_id'
    t.boolean  'three_month_bundle', default: false
    t.index ['shipping_id'], name: 'index_orders_on_shipping_id'
  end

  create_table 'shippings', force: :cascade do |t|
    t.string   'category',   default: 'standard'
    t.float    'charge',     default: 0.0
    t.datetime 'created_at',                      null: false
    t.datetime 'updated_at',                      null: false
  end
end
