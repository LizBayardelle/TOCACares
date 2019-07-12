require "application_system_test_case"

class HardshipsTest < ApplicationSystemTestCase
  setup do
    @hardship = hardships(:one)
  end

  test "visiting the index" do
    visit hardships_url
    assert_selector "h1", text: "Hardships"
  end

  test "creating a Hardship" do
    visit hardships_url
    click_on "New Hardship"

    check "Accident" if @hardship.accident
    fill_in "Address", with: @hardship.address
    fill_in "Bank address", with: @hardship.bank_address
    fill_in "Bank name", with: @hardship.bank_name
    fill_in "Bank phone", with: @hardship.bank_phone
    fill_in "Branch", with: @hardship.branch
    check "Catastrophe" if @hardship.catastrophe
    fill_in "City", with: @hardship.city
    check "Counseling" if @hardship.counseling
    fill_in "Date", with: @hardship.date
    fill_in "Email non toca", with: @hardship.email_non_toca
    check "Family emergency" if @hardship.family_emergency
    fill_in "Full name", with: @hardship.full_name
    fill_in "Hardship description", with: @hardship.hardship_description
    check "Health" if @hardship.health
    fill_in "Intent signature", with: @hardship.intent_signature
    fill_in "Intent signature date", with: @hardship.intent_signature_date
    check "Memorial" if @hardship.memorial
    fill_in "Mobile", with: @hardship.mobile
    check "Other hardship" if @hardship.other_hardship
    fill_in "Other hardship description", with: @hardship.other_hardship_description
    fill_in "Position", with: @hardship.position
    fill_in "Release signature", with: @hardship.release_signature
    fill_in "Release signature date", with: @hardship.release_signature_date
    fill_in "Requested amount", with: @hardship.requested_amount
    fill_in "Self fund", with: @hardship.self_fund
    fill_in "Start date", with: @hardship.start_date
    fill_in "State", with: @hardship.state
    fill_in "Status", with: @hardship.status
    fill_in "Zip", with: @hardship.zip
    click_on "Create Hardship"

    assert_text "Hardship was successfully created"
    click_on "Back"
  end

  test "updating a Hardship" do
    visit hardships_url
    click_on "Edit", match: :first

    check "Accident" if @hardship.accident
    fill_in "Address", with: @hardship.address
    fill_in "Bank address", with: @hardship.bank_address
    fill_in "Bank name", with: @hardship.bank_name
    fill_in "Bank phone", with: @hardship.bank_phone
    fill_in "Branch", with: @hardship.branch
    check "Catastrophe" if @hardship.catastrophe
    fill_in "City", with: @hardship.city
    check "Counseling" if @hardship.counseling
    fill_in "Date", with: @hardship.date
    fill_in "Email non toca", with: @hardship.email_non_toca
    check "Family emergency" if @hardship.family_emergency
    fill_in "Full name", with: @hardship.full_name
    fill_in "Hardship description", with: @hardship.hardship_description
    check "Health" if @hardship.health
    fill_in "Intent signature", with: @hardship.intent_signature
    fill_in "Intent signature date", with: @hardship.intent_signature_date
    check "Memorial" if @hardship.memorial
    fill_in "Mobile", with: @hardship.mobile
    check "Other hardship" if @hardship.other_hardship
    fill_in "Other hardship description", with: @hardship.other_hardship_description
    fill_in "Position", with: @hardship.position
    fill_in "Release signature", with: @hardship.release_signature
    fill_in "Release signature date", with: @hardship.release_signature_date
    fill_in "Requested amount", with: @hardship.requested_amount
    fill_in "Self fund", with: @hardship.self_fund
    fill_in "Start date", with: @hardship.start_date
    fill_in "State", with: @hardship.state
    fill_in "Status", with: @hardship.status
    fill_in "Zip", with: @hardship.zip
    click_on "Update Hardship"

    assert_text "Hardship was successfully updated"
    click_on "Back"
  end

  test "destroying a Hardship" do
    visit hardships_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hardship was successfully destroyed"
  end
end
