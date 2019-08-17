class CreateCharities < ActiveRecord::Migration[5.2]
  def change
    create_table :charities do |t|
      t.string :application_type, default: "charity"
      t.boolean :loan_preferred, default: false
      
      t.string :full_name
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
      t.string :institution_name
      t.string :institution_contact
      t.string :institution_phone
      t.string :institution_address
      t.decimal :requested_amount
      t.decimal :self_fund
      t.text :opportunity_description
      t.string :intent_signature
      t.date :intent_signature_date
      t.string :release_signature
      t.date :release_signature_date
      t.string :status, default: "Application Started"
      t.string :final_decision, default: "Not Decided"
      t.boolean :returned, default: false

      t.boolean :approved, default: false
      t.boolean :returned, default: false
      t.boolean :denied, default: false
      t.boolean :closed, default: false

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
