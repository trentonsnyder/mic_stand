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

ActiveRecord::Schema.define(version: 2018_05_16_035413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coupons", force: :cascade do |t|
    t.string "code", null: false
    t.integer "worth", null: false
  end

  create_table "credits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "coupon_id"
    t.bigint "purchase_id"
    t.index ["coupon_id"], name: "index_credits_on_coupon_id"
    t.index ["purchase_id"], name: "index_credits_on_purchase_id"
    t.index ["user_id"], name: "index_credits_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "broadcast_token", null: false
    t.datetime "session_expiry", null: false
    t.integer "duration", null: false
    t.bigint "user_id", null: false
    t.bigint "credit_id", null: false
    t.bigint "phone_number_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_id"], name: "index_events_on_credit_id"
    t.index ["phone_number_id"], name: "index_events_on_phone_number_id"
    t.index ["session_expiry"], name: "index_events_on_session_expiry"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body", null: false
    t.string "from", null: false
    t.datetime "selected"
    t.bigint "event_id", null: false
    t.index ["event_id"], name: "index_messages_on_event_id"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string "phone_number", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_phone_numbers_on_deleted_at"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "worth", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "role", default: "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
