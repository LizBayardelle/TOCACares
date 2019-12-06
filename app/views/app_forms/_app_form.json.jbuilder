json.extract! app_form, :id, :application_type, :full, :date, :position, :branch, :start_date, :email_non_toca, :mobile, :address, :city, :state, :zip, :for_other, :for_other_email, :recipient_toca_email, :transfer_pending, :bank_name, :bank_phone, :bank_address, :institution_name, :institution_contact, :institution_phone, :institution_address, :requested_amount, :self_fund, :loan_preferred, :loan_preferred_description, :description, :accident, :catastrophe, :counseling, :family_emergency, :health, :memorial, :other_hardship, :other_hardship_description, :intent_signature, :intent_signature_date, :release_signature, :release_signature_date, :approved, :denied, :returned, :closed, :application_status_id, :final_decision_id, :funding_status_id, :user_id, :created_at, :updated_at
json.url app_form_url(app_form, format: :json)