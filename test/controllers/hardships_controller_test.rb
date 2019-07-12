require 'test_helper'

class HardshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hardship = hardships(:one)
  end

  test "should get index" do
    get hardships_url
    assert_response :success
  end

  test "should get new" do
    get new_hardship_url
    assert_response :success
  end

  test "should create hardship" do
    assert_difference('Hardship.count') do
      post hardships_url, params: { hardship: { accident: @hardship.accident, address: @hardship.address, bank_address: @hardship.bank_address, bank_name: @hardship.bank_name, bank_phone: @hardship.bank_phone, branch: @hardship.branch, catastrophe: @hardship.catastrophe, city: @hardship.city, counseling: @hardship.counseling, date: @hardship.date, email_non_toca: @hardship.email_non_toca, family_emergency: @hardship.family_emergency, full_name: @hardship.full_name, hardship_description: @hardship.hardship_description, health: @hardship.health, intent_signature: @hardship.intent_signature, intent_signature_date: @hardship.intent_signature_date, memorial: @hardship.memorial, mobile: @hardship.mobile, other_hardship: @hardship.other_hardship, other_hardship_description: @hardship.other_hardship_description, position: @hardship.position, release_signature: @hardship.release_signature, release_signature_date: @hardship.release_signature_date, requested_amount: @hardship.requested_amount, self_fund: @hardship.self_fund, start_date: @hardship.start_date, state: @hardship.state, status: @hardship.status, zip: @hardship.zip } }
    end

    assert_redirected_to hardship_url(Hardship.last)
  end

  test "should show hardship" do
    get hardship_url(@hardship)
    assert_response :success
  end

  test "should get edit" do
    get edit_hardship_url(@hardship)
    assert_response :success
  end

  test "should update hardship" do
    patch hardship_url(@hardship), params: { hardship: { accident: @hardship.accident, address: @hardship.address, bank_address: @hardship.bank_address, bank_name: @hardship.bank_name, bank_phone: @hardship.bank_phone, branch: @hardship.branch, catastrophe: @hardship.catastrophe, city: @hardship.city, counseling: @hardship.counseling, date: @hardship.date, email_non_toca: @hardship.email_non_toca, family_emergency: @hardship.family_emergency, full_name: @hardship.full_name, hardship_description: @hardship.hardship_description, health: @hardship.health, intent_signature: @hardship.intent_signature, intent_signature_date: @hardship.intent_signature_date, memorial: @hardship.memorial, mobile: @hardship.mobile, other_hardship: @hardship.other_hardship, other_hardship_description: @hardship.other_hardship_description, position: @hardship.position, release_signature: @hardship.release_signature, release_signature_date: @hardship.release_signature_date, requested_amount: @hardship.requested_amount, self_fund: @hardship.self_fund, start_date: @hardship.start_date, state: @hardship.state, status: @hardship.status, zip: @hardship.zip } }
    assert_redirected_to hardship_url(@hardship)
  end

  test "should destroy hardship" do
    assert_difference('Hardship.count', -1) do
      delete hardship_url(@hardship)
    end

    assert_redirected_to hardships_url
  end
end
