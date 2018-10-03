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

ActiveRecord::Schema.define(version: 20180930171804) do

  create_table "card_details", force: :cascade do |t|
    t.integer "customer_id"
    t.string "card_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_card_details_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipping_address_details", force: :cascade do |t|
    t.integer "customer_id"
    t.string "name"
    t.string "address"
    t.string "country"
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_shipping_address_details_on_customer_id"
  end

  create_table "subscription_levels", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.string "billing_period", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_payments", force: :cascade do |t|
    t.string "status"
    t.string "error"
    t.datetime "valid_to"
    t.integer "subscription_id"
    t.integer "card_details_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_details_id"], name: "index_subscription_payments_on_card_details_id"
    t.index ["subscription_id"], name: "index_subscription_payments_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "subscription_level_id"
    t.integer "customer_id"
    t.integer "shipping_address_details_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["shipping_address_details_id"], name: "index_subscriptions_on_shipping_address_details_id"
    t.index ["subscription_level_id"], name: "index_subscriptions_on_subscription_level_id"
  end

end
