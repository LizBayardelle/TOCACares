require 'test_helper'

class ScholarshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scholarship = scholarships(:one)
  end

  test "should get index" do
    get scholarships_url
    assert_response :success
  end

  test "should get new" do
    get new_scholarship_url
    assert_response :success
  end

  test "should create scholarship" do
    assert_difference('Scholarship.count') do
      post scholarships_url, params: { scholarship: { address: @scholarship.address, approvals: @scholarship.approvals, branch: @scholarship.branch, city: @scholarship.city, date: @scholarship.date, email_non_toca: @scholarship.email_non_toca, final_decision: @scholarship.final_decision, full_name: @scholarship.full_name, institution_address: @scholarship.institution_address, institution_contact: @scholarship.institution_contact, institution_name: @scholarship.institution_name, institution_phone: @scholarship.institution_phone, intent_signature: @scholarship.intent_signature, intent_signature_date: @scholarship.intent_signature_date, mobile: @scholarship.mobile, position: @scholarship.position, rejections: @scholarship.rejections, release_signature: @scholarship.release_signature, release_signature_date: @scholarship.release_signature_date, requested_amount: @scholarship.requested_amount, returned: @scholarship.returned, scholarship_description: @scholarship.scholarship_description, self_fund: @scholarship.self_fund, start_date: @scholarship.start_date, state: @scholarship.state, status: @scholarship.status, user_id: @scholarship.user_id, zip: @scholarship.zip } }
    end

    assert_redirected_to scholarship_url(Scholarship.last)
  end

  test "should show scholarship" do
    get scholarship_url(@scholarship)
    assert_response :success
  end

  test "should get edit" do
    get edit_scholarship_url(@scholarship)
    assert_response :success
  end

  test "should update scholarship" do
    patch scholarship_url(@scholarship), params: { scholarship: { address: @scholarship.address, approvals: @scholarship.approvals, branch: @scholarship.branch, city: @scholarship.city, date: @scholarship.date, email_non_toca: @scholarship.email_non_toca, final_decision: @scholarship.final_decision, full_name: @scholarship.full_name, institution_address: @scholarship.institution_address, institution_contact: @scholarship.institution_contact, institution_name: @scholarship.institution_name, institution_phone: @scholarship.institution_phone, intent_signature: @scholarship.intent_signature, intent_signature_date: @scholarship.intent_signature_date, mobile: @scholarship.mobile, position: @scholarship.position, rejections: @scholarship.rejections, release_signature: @scholarship.release_signature, release_signature_date: @scholarship.release_signature_date, requested_amount: @scholarship.requested_amount, returned: @scholarship.returned, scholarship_description: @scholarship.scholarship_description, self_fund: @scholarship.self_fund, start_date: @scholarship.start_date, state: @scholarship.state, status: @scholarship.status, user_id: @scholarship.user_id, zip: @scholarship.zip } }
    assert_redirected_to scholarship_url(@scholarship)
  end

  test "should destroy scholarship" do
    assert_difference('Scholarship.count', -1) do
      delete scholarship_url(@scholarship)
    end

    assert_redirected_to scholarships_url
  end
end
