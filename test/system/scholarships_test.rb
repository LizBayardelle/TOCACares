require "application_system_test_case"

class ScholarshipsTest < ApplicationSystemTestCase
  setup do
    @scholarship = scholarships(:one)
  end

  test "visiting the index" do
    visit scholarships_url
    assert_selector "h1", text: "Scholarships"
  end

  test "creating a Scholarship" do
    visit scholarships_url
    click_on "New Scholarship"

    fill_in "Address", with: @scholarship.address
    fill_in "Approvals", with: @scholarship.approvals
    fill_in "Branch", with: @scholarship.branch
    fill_in "City", with: @scholarship.city
    fill_in "Date", with: @scholarship.date
    fill_in "Email non toca", with: @scholarship.email_non_toca
    fill_in "Final decision", with: @scholarship.final_decision
    fill_in "Full name", with: @scholarship.full_name
    fill_in "Institution address", with: @scholarship.institution_address
    fill_in "Institution contact", with: @scholarship.institution_contact
    fill_in "Institution name", with: @scholarship.institution_name
    fill_in "Institution phone", with: @scholarship.institution_phone
    fill_in "Intent signature", with: @scholarship.intent_signature
    fill_in "Intent signature date", with: @scholarship.intent_signature_date
    fill_in "Mobile", with: @scholarship.mobile
    fill_in "Position", with: @scholarship.position
    fill_in "Rejections", with: @scholarship.rejections
    fill_in "Release signature", with: @scholarship.release_signature
    fill_in "Release signature date", with: @scholarship.release_signature_date
    fill_in "Requested amount", with: @scholarship.requested_amount
    check "Returned" if @scholarship.returned
    fill_in "Scholarship description", with: @scholarship.scholarship_description
    fill_in "Self fund", with: @scholarship.self_fund
    fill_in "Start date", with: @scholarship.start_date
    fill_in "State", with: @scholarship.state
    fill_in "Status", with: @scholarship.status
    fill_in "User", with: @scholarship.user_id
    fill_in "Zip", with: @scholarship.zip
    click_on "Create Scholarship"

    assert_text "Scholarship was successfully created"
    click_on "Back"
  end

  test "updating a Scholarship" do
    visit scholarships_url
    click_on "Edit", match: :first

    fill_in "Address", with: @scholarship.address
    fill_in "Approvals", with: @scholarship.approvals
    fill_in "Branch", with: @scholarship.branch
    fill_in "City", with: @scholarship.city
    fill_in "Date", with: @scholarship.date
    fill_in "Email non toca", with: @scholarship.email_non_toca
    fill_in "Final decision", with: @scholarship.final_decision
    fill_in "Full name", with: @scholarship.full_name
    fill_in "Institution address", with: @scholarship.institution_address
    fill_in "Institution contact", with: @scholarship.institution_contact
    fill_in "Institution name", with: @scholarship.institution_name
    fill_in "Institution phone", with: @scholarship.institution_phone
    fill_in "Intent signature", with: @scholarship.intent_signature
    fill_in "Intent signature date", with: @scholarship.intent_signature_date
    fill_in "Mobile", with: @scholarship.mobile
    fill_in "Position", with: @scholarship.position
    fill_in "Rejections", with: @scholarship.rejections
    fill_in "Release signature", with: @scholarship.release_signature
    fill_in "Release signature date", with: @scholarship.release_signature_date
    fill_in "Requested amount", with: @scholarship.requested_amount
    check "Returned" if @scholarship.returned
    fill_in "Scholarship description", with: @scholarship.scholarship_description
    fill_in "Self fund", with: @scholarship.self_fund
    fill_in "Start date", with: @scholarship.start_date
    fill_in "State", with: @scholarship.state
    fill_in "Status", with: @scholarship.status
    fill_in "User", with: @scholarship.user_id
    fill_in "Zip", with: @scholarship.zip
    click_on "Update Scholarship"

    assert_text "Scholarship was successfully updated"
    click_on "Back"
  end

  test "destroying a Scholarship" do
    visit scholarships_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Scholarship was successfully destroyed"
  end
end
