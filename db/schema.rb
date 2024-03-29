# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2021_07_15_210615) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_forms", force: :cascade do |t|
    t.string "application_type"
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
    t.boolean "for_other", default: false
    t.string "for_other_email"
    t.string "recipient_toca_email"
    t.boolean "transfer_pending", default: false
    t.string "bank_name"
    t.string "bank_phone"
    t.string "bank_address"
    t.string "institution_name"
    t.string "institution_contact"
    t.string "institution_phone"
    t.string "institution_address"
    t.decimal "requested_amount"
    t.decimal "self_fund"
    t.boolean "loan_preferred", default: false
    t.string "loan_preferred_description"
    t.text "description"
    t.boolean "accident", default: false
    t.boolean "catastrophe", default: false
    t.boolean "counseling", default: false
    t.boolean "family_emergency", default: false
    t.boolean "health", default: false
    t.boolean "memorial", default: false
    t.boolean "other_hardship", default: false
    t.string "other_hardship_description"
    t.string "intent_signature"
    t.date "intent_signature_date"
    t.string "release_signature"
    t.date "release_signature_date"
    t.boolean "approved", default: false
    t.boolean "denied", default: false
    t.boolean "returned", default: false
    t.boolean "closed", default: false
    t.bigint "application_status_id"
    t.bigint "final_decision_id"
    t.bigint "funding_status_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "submitted", default: false
    t.index ["application_status_id"], name: "index_app_forms_on_application_status_id"
    t.index ["final_decision_id"], name: "index_app_forms_on_final_decision_id"
    t.index ["funding_status_id"], name: "index_app_forms_on_funding_status_id"
    t.index ["user_id"], name: "index_app_forms_on_user_id"
  end

  create_table "application_statuses", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "authorizations", force: :cascade do |t|
    t.string "email"
    t.boolean "admin", default: false
    t.boolean "committee", default: false
    t.boolean "account_created", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "charities", force: :cascade do |t|
    t.string "application_type", default: "charity"
    t.boolean "loan_preferred", default: false
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
    t.boolean "approved", default: false
    t.boolean "denied", default: false
    t.boolean "closed", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "funding_status", default: "Not Applicable"
    t.index ["user_id"], name: "index_charities_on_user_id"
  end

  create_table "final_decisions", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "funding_statuses", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "hardships", force: :cascade do |t|
    t.string "application_type", default: "hardship"
    t.boolean "loan_preferred", default: false
    t.boolean "for_other", default: false
    t.string "for_other_email"
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
    t.boolean "approved", default: false
    t.boolean "returned", default: false
    t.boolean "denied", default: false
    t.boolean "closed", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "funding_status", default: "Not Applicable"
    t.string "recipient_toca_email"
    t.boolean "transfer_pending", default: false
    t.index ["user_id"], name: "index_hardships_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "logs", force: :cascade do |t|
    t.string "category", default: "Other"
    t.string "action"
    t.boolean "automatic", default: false
    t.boolean "object", default: false
    t.boolean "object_linkable", default: false
    t.string "object_category"
    t.integer "object_id"
    t.boolean "taken_by_user", default: false
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "archived", default: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "pretransfers", force: :cascade do |t|
    t.string "toca_email"
    t.string "application_type"
    t.integer "application_id"
    t.boolean "open", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "body"
    t.boolean "answered", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "message_id"
    t.text "body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["message_id"], name: "index_responses_on_message_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "scholarships", force: :cascade do |t|
    t.string "application_type", default: "scholarship"
    t.boolean "loan_preferred", default: false
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
    t.boolean "approved", default: false
    t.boolean "returned", default: false
    t.boolean "denied", default: false
    t.boolean "closed", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_testimonials_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "variations", force: :cascade do |t|
    t.bigint "app_form_id"
    t.bigint "original_app_form_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["app_form_id", "original_app_form_id"], name: "index_variations_on_app_form_id_and_original_app_form_id", unique: true
    t.index ["app_form_id"], name: "index_variations_on_app_form_id"
    t.index ["original_app_form_id"], name: "index_variations_on_original_app_form_id"
    t.index ["user_id"], name: "index_variations_on_user_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "application_type"
    t.integer "application_id"
    t.boolean "accept", default: false
    t.boolean "modify", default: false
    t.text "modification"
    t.boolean "suggest_loan", default: false
    t.text "describe_loan", default: "f"
    t.boolean "deny", default: false
    t.boolean "denial_fund_overuse", default: false
    t.boolean "denial_not_qualify", default: false
    t.boolean "denial_unreasonable_request", default: false
    t.boolean "denial_not_involved_charity", default: false
    t.boolean "denial_other", default: false
    t.text "denial_other_description"
    t.boolean "superseded", default: false
    t.boolean "seconded", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "modifications_accepted_by_applicant", default: false
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "app_forms", "application_statuses"
  add_foreign_key "app_forms", "final_decisions"
  add_foreign_key "app_forms", "funding_statuses"
  add_foreign_key "app_forms", "users"
  add_foreign_key "charities", "users"
  add_foreign_key "hardships", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "responses", "messages"
  add_foreign_key "responses", "users"
  add_foreign_key "scholarships", "users"
  add_foreign_key "testimonials", "users"
  add_foreign_key "variations", "users"
  add_foreign_key "votes", "users"
end
