require 'test_helper'

class CharitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @charity = charities(:one)
  end

  test "should get index" do
    get charities_url
    assert_response :success
  end

  test "should get new" do
    get new_charity_url
    assert_response :success
  end

  test "should create charity" do
    assert_difference('Charity.count') do
      post charities_url, params: { charity: { address: @charity.address, approvals: @charity.approvals, branch: @charity.branch, city: @charity.city, date: @charity.date, email_non_toca: @charity.email_non_toca, final_decision: @charity.final_decision, full_name: @charity.full_name, institution_address: @charity.institution_address, institution_contact: @charity.institution_contact, institution_name: @charity.institution_name, institution_phone: @charity.institution_phone, intent_signature: @charity.intent_signature, intent_signature_date: @charity.intent_signature_date, mobile: @charity.mobile, opportunity_description: @charity.opportunity_description, position: @charity.position, rejections: @charity.rejections, release_signature: @charity.release_signature, release_signature_date: @charity.release_signature_date, requested_amount: @charity.requested_amount, returned: @charity.returned, self_fund: @charity.self_fund, start_date: @charity.start_date, state: @charity.state, status: @charity.status, user_id: @charity.user_id, zip: @charity.zip } }
    end

    assert_redirected_to charity_url(Charity.last)
  end

  test "should show charity" do
    get charity_url(@charity)
    assert_response :success
  end

  test "should get edit" do
    get edit_charity_url(@charity)
    assert_response :success
  end

  test "should update charity" do
    patch charity_url(@charity), params: { charity: { address: @charity.address, approvals: @charity.approvals, branch: @charity.branch, city: @charity.city, date: @charity.date, email_non_toca: @charity.email_non_toca, final_decision: @charity.final_decision, full_name: @charity.full_name, institution_address: @charity.institution_address, institution_contact: @charity.institution_contact, institution_name: @charity.institution_name, institution_phone: @charity.institution_phone, intent_signature: @charity.intent_signature, intent_signature_date: @charity.intent_signature_date, mobile: @charity.mobile, opportunity_description: @charity.opportunity_description, position: @charity.position, rejections: @charity.rejections, release_signature: @charity.release_signature, release_signature_date: @charity.release_signature_date, requested_amount: @charity.requested_amount, returned: @charity.returned, self_fund: @charity.self_fund, start_date: @charity.start_date, state: @charity.state, status: @charity.status, user_id: @charity.user_id, zip: @charity.zip } }
    assert_redirected_to charity_url(@charity)
  end

  test "should destroy charity" do
    assert_difference('Charity.count', -1) do
      delete charity_url(@charity)
    end

    assert_redirected_to charities_url
  end
end
