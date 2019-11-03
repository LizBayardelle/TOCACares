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

ActiveRecord::Schema.define(version: 2019_11_01_041844) do

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
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "application_type", default: "charity"
    t.boolean "loan_preferred", default: false
    t.boolean "closed", default: false
    t.boolean "denied", default: false
    t.boolean "approved", default: false
    t.string "funding_status", default: "Not Applicable"
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
    t.string "application_type", default: "hardship"
    t.boolean "loan_preferred", default: false
    t.boolean "for_other", default: false
    t.string "for_other_email"
    t.boolean "closed", default: false
    t.boolean "denied", default: false
    t.boolean "approved", default: false
    t.string "funding_status", default: "Not Applicable"
    t.string "recipient_toca_email"
    t.boolean "transfer_pending", default: false
    t.index ["user_id"], name: "index_hardships_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "category", default: "Other"
    t.string "action"
    t.boolean "automatic", default: false
    t.boolean "object", default: false
    t.string "object_category"
    t.integer "object_id"
    t.boolean "taken_by_user", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "object_linkable", default: false
    t.integer "user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "from_user_id"
    t.bigint "user_id"
    t.string "subject"
    t.text "message"
    t.boolean "read", default: false
    t.string "ref_application_type"
    t.integer "ref_application_id"
    t.boolean "issue_closed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "pretransfers", force: :cascade do |t|
    t.string "toca_email"
    t.string "application_type"
    t.integer "application_id"
    t.boolean "open", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "body"
    t.boolean "answered", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "message_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_responses_on_message_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
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
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "application_type", default: "scholarship"
    t.boolean "loan_preferred", default: false
    t.boolean "closed", default: false
    t.boolean "denied", default: false
    t.boolean "approved", default: false
    t.string "funding_status", default: "Not Applicable"
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
    t.boolean "authorized_by_admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "values", force: :cascade do |t|
    t.string "current_year"
    t.string "matching_ratio"
    t.string "individual_contributions"
    t.string "shareholder_matching"
    t.string "total_fund_value"
    t.boolean "selected", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.string "application_type"
    t.integer "application_id"
    t.boolean "accept", default: false
    t.boolean "modify", default: false
    t.text "modification"
    t.boolean "suggest_loan", default: false
    t.text "describe_loan"
    t.boolean "deny", default: false
    t.boolean "denial_fund_overuse", default: false
    t.boolean "denial_not_qualify", default: false
    t.boolean "denial_unreasonable_request", default: false
    t.boolean "denial_not_involved_charity", default: false
    t.boolean "denial_other", default: false
    t.text "denial_other_description"
    t.boolean "superseded", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "seconded", default: false
    t.boolean "modifications_accepted_by_applicant", default: false
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "charities", "users"
  add_foreign_key "hardships", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "responses", "messages"
  add_foreign_key "responses", "users"
  add_foreign_key "scholarships", "users"
  add_foreign_key "testimonials", "users"
  add_foreign_key "votes", "users"
end
