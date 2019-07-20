require "application_system_test_case"

class CharitiesTest < ApplicationSystemTestCase
  setup do
    @charity = charities(:one)
  end

  test "visiting the index" do
    visit charities_url
    assert_selector "h1", text: "Charities"
  end

  test "creating a Charity" do
    visit charities_url
    click_on "New Charity"

    fill_in "Address", with: @charity.address
    fill_in "Approvals", with: @charity.approvals
    fill_in "Branch", with: @charity.branch
    fill_in "City", with: @charity.city
    fill_in "Date", with: @charity.date
    fill_in "Email non toca", with: @charity.email_non_toca
    fill_in "Final decision", with: @charity.final_decision
    fill_in "Full name", with: @charity.full_name
    fill_in "Institution address", with: @charity.institution_address
    fill_in "Institution contact", with: @charity.institution_contact
    fill_in "Institution name", with: @charity.institution_name
    fill_in "Institution phone", with: @charity.institution_phone
    fill_in "Intent signature", with: @charity.intent_signature
    fill_in "Intent signature date", with: @charity.intent_signature_date
    fill_in "Mobile", with: @charity.mobile
    fill_in "Opportunity description", with: @charity.opportunity_description
    fill_in "Position", with: @charity.position
    fill_in "Rejections", with: @charity.rejections
    fill_in "Release signature", with: @charity.release_signature
    fill_in "Release signature date", with: @charity.release_signature_date
    fill_in "Requested amount", with: @charity.requested_amount
    check "Returned" if @charity.returned
    fill_in "Self fund", with: @charity.self_fund
    fill_in "Start date", with: @charity.start_date
    fill_in "State", with: @charity.state
    fill_in "Status", with: @charity.status
    fill_in "User", with: @charity.user_id
    fill_in "Zip", with: @charity.zip
    click_on "Create Charity"

    assert_text "Charity was successfully created"
    click_on "Back"
  end

  test "updating a Charity" do
    visit charities_url
    click_on "Edit", match: :first

    fill_in "Address", with: @charity.address
    fill_in "Approvals", with: @charity.approvals
    fill_in "Branch", with: @charity.branch
    fill_in "City", with: @charity.city
    fill_in "Date", with: @charity.date
    fill_in "Email non toca", with: @charity.email_non_toca
    fill_in "Final decision", with: @charity.final_decision
    fill_in "Full name", with: @charity.full_name
    fill_in "Institution address", with: @charity.institution_address
    fill_in "Institution contact", with: @charity.institution_contact
    fill_in "Institution name", with: @charity.institution_name
    fill_in "Institution phone", with: @charity.institution_phone
    fill_in "Intent signature", with: @charity.intent_signature
    fill_in "Intent signature date", with: @charity.intent_signature_date
    fill_in "Mobile", with: @charity.mobile
    fill_in "Opportunity description", with: @charity.opportunity_description
    fill_in "Position", with: @charity.position
    fill_in "Rejections", with: @charity.rejections
    fill_in "Release signature", with: @charity.release_signature
    fill_in "Release signature date", with: @charity.release_signature_date
    fill_in "Requested amount", with: @charity.requested_amount
    check "Returned" if @charity.returned
    fill_in "Self fund", with: @charity.self_fund
    fill_in "Start date", with: @charity.start_date
    fill_in "State", with: @charity.state
    fill_in "Status", with: @charity.status
    fill_in "User", with: @charity.user_id
    fill_in "Zip", with: @charity.zip
    click_on "Update Charity"

    assert_text "Charity was successfully updated"
    click_on "Back"
  end

  test "destroying a Charity" do
    visit charities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Charity was successfully destroyed"
  end
end
