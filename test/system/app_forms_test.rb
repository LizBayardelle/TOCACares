require "application_system_test_case"

class AppFormsTest < ApplicationSystemTestCase
  setup do
    @app_form = app_forms(:one)
  end

  test "visiting the index" do
    visit app_forms_url
    assert_selector "h1", text: "App Forms"
  end

  test "creating a App form" do
    visit app_forms_url
    click_on "New App Form"

    check "Accident" if @app_form.accident
    fill_in "Address", with: @app_form.address
    fill_in "Application status", with: @app_form.application_status_id
    fill_in "Application type", with: @app_form.application_type
    check "Approved" if @app_form.approved
    fill_in "Bank address", with: @app_form.bank_address
    fill_in "Bank name", with: @app_form.bank_name
    fill_in "Bank phone", with: @app_form.bank_phone
    fill_in "Branch", with: @app_form.branch
    check "Catastrophe" if @app_form.catastrophe
    fill_in "City", with: @app_form.city
    check "Closed" if @app_form.closed
    check "Counseling" if @app_form.counseling
    fill_in "Date", with: @app_form.date
    check "Denied" if @app_form.denied
    fill_in "Description", with: @app_form.description
    fill_in "Email non toca", with: @app_form.email_non_toca
    check "Family emergency" if @app_form.family_emergency
    fill_in "Final decision", with: @app_form.final_decision_id
    check "For other" if @app_form.for_other
    fill_in "For other email", with: @app_form.for_other_email
    fill_in "Full", with: @app_form.full
    fill_in "Funding status", with: @app_form.funding_status_id
    check "Health" if @app_form.health
    fill_in "Institution address", with: @app_form.institution_address
    fill_in "Institution contact", with: @app_form.institution_contact
    fill_in "Institution name", with: @app_form.institution_name
    fill_in "Institution phone", with: @app_form.institution_phone
    fill_in "Intent signature", with: @app_form.intent_signature
    fill_in "Intent signature date", with: @app_form.intent_signature_date
    check "Loan preferred" if @app_form.loan_preferred
    check "Loan preferred description" if @app_form.loan_preferred_description
    check "Memorial" if @app_form.memorial
    fill_in "Mobile", with: @app_form.mobile
    check "Other hardship" if @app_form.other_hardship
    fill_in "Other hardship description", with: @app_form.other_hardship_description
    fill_in "Position", with: @app_form.position
    fill_in "Recipient toca email", with: @app_form.recipient_toca_email
    fill_in "Release signature", with: @app_form.release_signature
    fill_in "Release signature date", with: @app_form.release_signature_date
    fill_in "Requested amount", with: @app_form.requested_amount
    check "Returned" if @app_form.returned
    fill_in "Self fund", with: @app_form.self_fund
    fill_in "Start date", with: @app_form.start_date
    fill_in "State", with: @app_form.state
    check "Transfer pending" if @app_form.transfer_pending
    fill_in "User", with: @app_form.user_id
    fill_in "Zip", with: @app_form.zip
    click_on "Create App form"

    assert_text "App form was successfully created"
    click_on "Back"
  end

  test "updating a App form" do
    visit app_forms_url
    click_on "Edit", match: :first

    check "Accident" if @app_form.accident
    fill_in "Address", with: @app_form.address
    fill_in "Application status", with: @app_form.application_status_id
    fill_in "Application type", with: @app_form.application_type
    check "Approved" if @app_form.approved
    fill_in "Bank address", with: @app_form.bank_address
    fill_in "Bank name", with: @app_form.bank_name
    fill_in "Bank phone", with: @app_form.bank_phone
    fill_in "Branch", with: @app_form.branch
    check "Catastrophe" if @app_form.catastrophe
    fill_in "City", with: @app_form.city
    check "Closed" if @app_form.closed
    check "Counseling" if @app_form.counseling
    fill_in "Date", with: @app_form.date
    check "Denied" if @app_form.denied
    fill_in "Description", with: @app_form.description
    fill_in "Email non toca", with: @app_form.email_non_toca
    check "Family emergency" if @app_form.family_emergency
    fill_in "Final decision", with: @app_form.final_decision_id
    check "For other" if @app_form.for_other
    fill_in "For other email", with: @app_form.for_other_email
    fill_in "Full", with: @app_form.full
    fill_in "Funding status", with: @app_form.funding_status_id
    check "Health" if @app_form.health
    fill_in "Institution address", with: @app_form.institution_address
    fill_in "Institution contact", with: @app_form.institution_contact
    fill_in "Institution name", with: @app_form.institution_name
    fill_in "Institution phone", with: @app_form.institution_phone
    fill_in "Intent signature", with: @app_form.intent_signature
    fill_in "Intent signature date", with: @app_form.intent_signature_date
    check "Loan preferred" if @app_form.loan_preferred
    check "Loan preferred description" if @app_form.loan_preferred_description
    check "Memorial" if @app_form.memorial
    fill_in "Mobile", with: @app_form.mobile
    check "Other hardship" if @app_form.other_hardship
    fill_in "Other hardship description", with: @app_form.other_hardship_description
    fill_in "Position", with: @app_form.position
    fill_in "Recipient toca email", with: @app_form.recipient_toca_email
    fill_in "Release signature", with: @app_form.release_signature
    fill_in "Release signature date", with: @app_form.release_signature_date
    fill_in "Requested amount", with: @app_form.requested_amount
    check "Returned" if @app_form.returned
    fill_in "Self fund", with: @app_form.self_fund
    fill_in "Start date", with: @app_form.start_date
    fill_in "State", with: @app_form.state
    check "Transfer pending" if @app_form.transfer_pending
    fill_in "User", with: @app_form.user_id
    fill_in "Zip", with: @app_form.zip
    click_on "Update App form"

    assert_text "App form was successfully updated"
    click_on "Back"
  end

  test "destroying a App form" do
    visit app_forms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App form was successfully destroyed"
  end
end
