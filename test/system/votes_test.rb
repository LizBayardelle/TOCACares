require "application_system_test_case"

class VotesTest < ApplicationSystemTestCase
  setup do
    @vote = votes(:one)
  end

  test "visiting the index" do
    visit votes_url
    assert_selector "h1", text: "Votes"
  end

  test "creating a Vote" do
    visit votes_url
    click_on "New Vote"

    check "Accept" if @vote.accept
    fill_in "Application", with: @vote.application_id
    fill_in "Application type", with: @vote.application_type
    check "Denial fund overuse" if @vote.denial_fund_overuse
    check "Denial not involved charity" if @vote.denial_not_involved_charity
    check "Denial not qualify" if @vote.denial_not_qualify
    check "Denial other" if @vote.denial_other
    fill_in "Denial other description", with: @vote.denial_other_description
    check "Denial unreasonable request" if @vote.denial_unreasonable_request
    check "Deny" if @vote.deny
    fill_in "Describe loan", with: @vote.describe_loan
    fill_in "Modification", with: @vote.modification
    check "Modify" if @vote.modify
    fill_in "References", with: @vote.references
    check "Suggest loan" if @vote.suggest_loan
    check "Superseded" if @vote.superseded
    click_on "Create Vote"

    assert_text "Vote was successfully created"
    click_on "Back"
  end

  test "updating a Vote" do
    visit votes_url
    click_on "Edit", match: :first

    check "Accept" if @vote.accept
    fill_in "Application", with: @vote.application_id
    fill_in "Application type", with: @vote.application_type
    check "Denial fund overuse" if @vote.denial_fund_overuse
    check "Denial not involved charity" if @vote.denial_not_involved_charity
    check "Denial not qualify" if @vote.denial_not_qualify
    check "Denial other" if @vote.denial_other
    fill_in "Denial other description", with: @vote.denial_other_description
    check "Denial unreasonable request" if @vote.denial_unreasonable_request
    check "Deny" if @vote.deny
    fill_in "Describe loan", with: @vote.describe_loan
    fill_in "Modification", with: @vote.modification
    check "Modify" if @vote.modify
    fill_in "References", with: @vote.references
    check "Suggest loan" if @vote.suggest_loan
    check "Superseded" if @vote.superseded
    click_on "Update Vote"

    assert_text "Vote was successfully updated"
    click_on "Back"
  end

  test "destroying a Vote" do
    visit votes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Vote was successfully destroyed"
  end
end
