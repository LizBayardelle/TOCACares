require 'test_helper'

class AppFormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_form = app_forms(:one)
  end

  test "should get index" do
    get app_forms_url
    assert_response :success
  end

  test "should get new" do
    get new_app_form_url
    assert_response :success
  end

  test "should create app_form" do
    assert_difference('AppForm.count') do
      post app_forms_url, params: { app_form: { accident: @app_form.accident, address: @app_form.address, application_status_id: @app_form.application_status_id, application_type: @app_form.application_type, approved: @app_form.approved, bank_address: @app_form.bank_address, bank_name: @app_form.bank_name, bank_phone: @app_form.bank_phone, branch: @app_form.branch, catastrophe: @app_form.catastrophe, city: @app_form.city, closed: @app_form.closed, counseling: @app_form.counseling, date: @app_form.date, denied: @app_form.denied, description: @app_form.description, email_non_toca: @app_form.email_non_toca, family_emergency: @app_form.family_emergency, final_decision_id: @app_form.final_decision_id, for_other: @app_form.for_other, for_other_email: @app_form.for_other_email, full: @app_form.full, funding_status_id: @app_form.funding_status_id, health: @app_form.health, institution_address: @app_form.institution_address, institution_contact: @app_form.institution_contact, institution_name: @app_form.institution_name, institution_phone: @app_form.institution_phone, intent_signature: @app_form.intent_signature, intent_signature_date: @app_form.intent_signature_date, loan_preferred: @app_form.loan_preferred, loan_preferred_description: @app_form.loan_preferred_description, memorial: @app_form.memorial, mobile: @app_form.mobile, other_hardship: @app_form.other_hardship, other_hardship_description: @app_form.other_hardship_description, position: @app_form.position, recipient_toca_email: @app_form.recipient_toca_email, release_signature: @app_form.release_signature, release_signature_date: @app_form.release_signature_date, requested_amount: @app_form.requested_amount, returned: @app_form.returned, self_fund: @app_form.self_fund, start_date: @app_form.start_date, state: @app_form.state, transfer_pending: @app_form.transfer_pending, user_id: @app_form.user_id, zip: @app_form.zip } }
    end

    assert_redirected_to app_form_url(AppForm.last)
  end

  test "should show app_form" do
    get app_form_url(@app_form)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_form_url(@app_form)
    assert_response :success
  end

  test "should update app_form" do
    patch app_form_url(@app_form), params: { app_form: { accident: @app_form.accident, address: @app_form.address, application_status_id: @app_form.application_status_id, application_type: @app_form.application_type, approved: @app_form.approved, bank_address: @app_form.bank_address, bank_name: @app_form.bank_name, bank_phone: @app_form.bank_phone, branch: @app_form.branch, catastrophe: @app_form.catastrophe, city: @app_form.city, closed: @app_form.closed, counseling: @app_form.counseling, date: @app_form.date, denied: @app_form.denied, description: @app_form.description, email_non_toca: @app_form.email_non_toca, family_emergency: @app_form.family_emergency, final_decision_id: @app_form.final_decision_id, for_other: @app_form.for_other, for_other_email: @app_form.for_other_email, full: @app_form.full, funding_status_id: @app_form.funding_status_id, health: @app_form.health, institution_address: @app_form.institution_address, institution_contact: @app_form.institution_contact, institution_name: @app_form.institution_name, institution_phone: @app_form.institution_phone, intent_signature: @app_form.intent_signature, intent_signature_date: @app_form.intent_signature_date, loan_preferred: @app_form.loan_preferred, loan_preferred_description: @app_form.loan_preferred_description, memorial: @app_form.memorial, mobile: @app_form.mobile, other_hardship: @app_form.other_hardship, other_hardship_description: @app_form.other_hardship_description, position: @app_form.position, recipient_toca_email: @app_form.recipient_toca_email, release_signature: @app_form.release_signature, release_signature_date: @app_form.release_signature_date, requested_amount: @app_form.requested_amount, returned: @app_form.returned, self_fund: @app_form.self_fund, start_date: @app_form.start_date, state: @app_form.state, transfer_pending: @app_form.transfer_pending, user_id: @app_form.user_id, zip: @app_form.zip } }
    assert_redirected_to app_form_url(@app_form)
  end

  test "should destroy app_form" do
    assert_difference('AppForm.count', -1) do
      delete app_form_url(@app_form)
    end

    assert_redirected_to app_forms_url
  end
end
