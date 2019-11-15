class CreateAppForms < ActiveRecord::Migration[5.2]
  def change
    create_table :app_forms do |t|
      t.string :application_type
      t.string :full
      t.date :date
      t.string :position
      t.string :branch
      t.date :start_date
      t.string :email_non_toca
      t.string :mobile
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.boolean :for_other, default: false
      t.string :for_other_email
      t.string :recipient_toca_email
      t.boolean :transfer_pending, default: false
      t.string :bank_name
      t.string :bank_phone
      t.string :bank_address
      t.string :institution_name
      t.string :institution_contact
      t.string :institution_phone
      t.string :institution_address
      t.decimal :requested_amount
      t.decimal :self_fund
      t.boolean :loan_preferred, default: false
      t.string :loan_preferred_description
      t.text :description
      t.boolean :accident, default: false
      t.boolean :catastrophe, default: false
      t.boolean :counseling, default: false
      t.boolean :family_emergency, default: false
      t.boolean :health, default: false
      t.boolean :memorial, default: false
      t.boolean :other_hardship, default: false
      t.string :other_hardship_description
      t.string :intent_signature
      t.date :intent_signature_date
      t.string :release_signature
      t.date :release_signature_date
      t.boolean :approved, default: false
      t.boolean :denied, default: false
      t.boolean :returned, default: false
      t.boolean :closed, default: false
      t.references :application_status, foreign_key: true
      t.references :final_decision, foreign_key: true
      t.references :funding_status, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
