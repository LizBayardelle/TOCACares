class CreateHardships < ActiveRecord::Migration[5.2]
  def change
    create_table :hardships do |t|
      t.string :full_name
      t.date :date
      t.string :position
      t.string :branch
      t.string :email_non_toca
      t.string :mobile
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :bank_name
      t.string :bank_phone
      t.string :bank_address
      t.date :start_date
      t.boolean :accident, default: false
      t.boolean :catastrophe, default: false
      t.boolean :counseling, default: false
      t.boolean :family_emergency, default: false
      t.boolean :health, default: false
      t.boolean :memorial, default: false
      t.boolean :other_hardship, default: false
      t.string :other_hardship_description
      t.decimal :requested_amount
      t.text :hardship_description
      t.decimal :self_fund
      t.string :intent_signature
      t.date :intent_signature_date
      t.string :release_signature
      t.date :release_signature_date
      t.string :status, default: "Application Started"
      t.string :review_first_status
      t.string :review_first_reviewer_id
      t.string :review_second
      t.string :review_second_reviewer_id
      t.string :final_decision, default: "Not Decided"
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
