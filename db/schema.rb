# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_28_091249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "autocompletes", force: :cascade do |t|
    t.string "address"
    t.integer "street_number"
    t.string "locality"
    t.string "route"
    t.string "administrative_area_level_1"
    t.string "country"
    t.integer "postal_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "baskets", force: :cascade do |t|
    t.decimal "subtotal"
    t.decimal "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "quantity"
    t.bigint "order_id", null: false
    t.bigint "basket_id", null: false
    t.decimal "total"
    t.decimal "unit_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["basket_id"], name: "index_order_items_on_basket_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "from_address"
    t.integer "from_street_number"
    t.string "from_locality"
    t.string "from_route"
    t.string "from_administrative_area_level_1"
    t.string "from_country"
    t.integer "from_postal_code"
    t.string "to_address"
    t.integer "to_street_number"
    t.string "to_locality"
    t.string "to_route"
    t.string "to_administrative_area_level_1"
    t.string "to_country"
    t.integer "to_postal_code"
    t.string "size"
    t.float "to_latitude"
    t.float "to_longitude"
    t.float "from_latitude"
    t.float "from_longitude"
    t.string "to_sublocality"
    t.string "from_sublocality"
    t.string "to_faddress"
    t.string "from_faddress"
    t.text "customer_ref"
    t.boolean "is_for_contract_driver"
    t.string "warehouse_id"
    t.integer "from_unit_no"
    t.string "from_complex"
    t.string "from_name"
    t.string "from_email"
    t.string "from_phone"
    t.string "from_special_instructions"
    t.integer "to_unit_no"
    t.string "to_complex"
    t.string "to_name"
    t.string "to_email"
    t.string "to_phone"
    t.string "to_special_instructions"
    t.string "to_quote_ref"
    t.boolean "processed", default: false
    t.string "scheduled_date"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "parcels", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "size"
    t.string "reference"
    t.string "quote_ref"
    t.string "tracking_number"
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_parcels_on_order_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "body"
  end

  create_table "quotes", force: :cascade do |t|
    t.string "price_incl_vat"
    t.bigint "order_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "quote_response"
    t.string "vehicle_id"
    t.index ["order_id"], name: "index_quotes_on_order_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.string "unconfirmed_email"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "order_items", "baskets"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "parcels", "orders"
  add_foreign_key "quotes", "orders"
end
