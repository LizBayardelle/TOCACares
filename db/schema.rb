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

ActiveRecord::Schema.define(version: 2019_08_11_202845) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.string "email"
    t.boolean "admin", default: false
    t.boolean "committee", default: false
    t.boolean "account_created", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charities", force: :cascade do |t|
    t.string "full_name"
    t.date "date"
    t.string "position"
    t.string "branch"
    t.date "start_date"
    t.string "email_non_toca"
    t.string "mobile"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "institution_name"
    t.string "institution_contact"
    t.string "institution_phone"
    t.string "institution_address"
    t.decimal "requested_amount"
    t.decimal "self_fund"
    t.text "opportunity_description"
    t.string "intent_signature"
    t.date "intent_signature_date"
    t.string "release_signature"
    t.date "release_signature_date"
    t.string "status", default: "Application Started"
    t.string "final_decision", default: "Not Decided"
    t.boolean "returned", default: false
    t.text "approvals", default: [], array: true
    t.text "rejections", default: [], array: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "application_type", default: "charity"
    t.boolean "loan_preferred", default: false
    t.index ["user_id"], name: "index_charities_on_user_id"
  end

  create_table "hardships", force: :cascade do |t|
    t.string "full_name"
    t.date "date"
    t.string "position"
    t.string "branch"
    t.string "email_non_toca"
    t.string "mobile"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "bank_name"
    t.string "bank_phone"
    t.string "bank_address"
    t.date "start_date"
    t.boolean "accident", default: false
    t.boolean "catastrophe", default: false
    t.boolean "counseling", default: false
    t.boolean "family_emergency", default: false
    t.boolean "health", default: false
    t.boolean "memorial", default: false
    t.boolean "other_hardship", default: false
    t.string "other_hardship_description"
    t.decimal "requested_amount"
    t.text "hardship_description"
    t.decimal "self_fund"
    t.string "intent_signature"
    t.date "intent_signature_date"
    t.string "release_signature"
    t.date "release_signature_date"
    t.string "status", default: "Application Started"
    t.string "final_decision", default: "Not Decided"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "returned", default: false
    t.text "approvals", default: [], array: true
    t.text "rejections", default: [], array: true
    t.string "application_type", default: "hardship"
    t.boolean "loan_preferred", default: false
    t.boolean "for_other", default: false
    t.index ["user_id"], name: "index_hardships_on_user_id"
  end

  create_table "modifications", force: :cascade do |t|
    t.text "body"
    t.boolean "seconded", default: false
    t.string "modifiable_type"
    t.bigint "modifiable_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "app_type"
    t.integer "app_id"
    t.boolean "superseded", default: false
    t.index ["modifiable_type", "modifiable_id"], name: "index_modifications_on_modifiable_type_and_modifiable_id"
    t.index ["user_id"], name: "index_modifications_on_user_id"
  end

  create_table "scholarships", force: :cascade do |t|
    t.string "full_name"
    t.date "date"
    t.string "position"
    t.string "branch"
    t.date "start_date"
    t.string "email_non_toca"
    t.string "mobile"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "institution_name"
    t.string "institution_contact"
    t.string "institution_phone"
    t.string "institution_address"
    t.decimal "requested_amount"
    t.decimal "self_fund"
    t.text "scholarship_description"
    t.string "intent_signature"
    t.date "intent_signature_date"
    t.string "release_signature"
    t.date "release_signature_date"
    t.string "status", default: "Application Started"
    t.string "final_decision", default: "Not Decided"
    t.boolean "returned", default: false
    t.text "approvals", default: [], array: true
    t.text "rejections", default: [], array: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "application_type", default: "scholarship"
    t.boolean "loan_preferred", default: false
    t.index ["user_id"], name: "index_scholarships_on_user_id"
  end

  create_table "testimonials", force: :cascade do |t|
    t.string "category"
    t.string "title"
    t.string "body"
    t.boolean "featured", default: false
    t.boolean "approved", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_testimonials_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.boolean "committee", default: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "location"
    t.string "committee_request", default: "None"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "charities", "users"
  add_foreign_key "hardships", "users"
  add_foreign_key "modifications", "users"
  add_foreign_key "scholarships", "users"
  add_foreign_key "testimonials", "users"
end
