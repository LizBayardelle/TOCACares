require 'test_helper'

class VotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vote = votes(:one)
  end

  test "should get index" do
    get votes_url
    assert_response :success
  end

  test "should get new" do
    get new_vote_url
    assert_response :success
  end

  test "should create vote" do
    assert_difference('Vote.count') do
      post votes_url, params: { vote: { accept: @vote.accept, application_id: @vote.application_id, application_type: @vote.application_type, denial_fund_overuse: @vote.denial_fund_overuse, denial_not_involved_charity: @vote.denial_not_involved_charity, denial_not_qualify: @vote.denial_not_qualify, denial_other: @vote.denial_other, denial_other_description: @vote.denial_other_description, denial_unreasonable_request: @vote.denial_unreasonable_request, deny: @vote.deny, describe_loan: @vote.describe_loan, modification: @vote.modification, modify: @vote.modify, references: @vote.references, suggest_loan: @vote.suggest_loan, superseded: @vote.superseded } }
    end

    assert_redirected_to vote_url(Vote.last)
  end

  test "should show vote" do
    get vote_url(@vote)
    assert_response :success
  end

  test "should get edit" do
    get edit_vote_url(@vote)
    assert_response :success
  end

  test "should update vote" do
    patch vote_url(@vote), params: { vote: { accept: @vote.accept, application_id: @vote.application_id, application_type: @vote.application_type, denial_fund_overuse: @vote.denial_fund_overuse, denial_not_involved_charity: @vote.denial_not_involved_charity, denial_not_qualify: @vote.denial_not_qualify, denial_other: @vote.denial_other, denial_other_description: @vote.denial_other_description, denial_unreasonable_request: @vote.denial_unreasonable_request, deny: @vote.deny, describe_loan: @vote.describe_loan, modification: @vote.modification, modify: @vote.modify, references: @vote.references, suggest_loan: @vote.suggest_loan, superseded: @vote.superseded } }
    assert_redirected_to vote_url(@vote)
  end

  test "should destroy vote" do
    assert_difference('Vote.count', -1) do
      delete vote_url(@vote)
    end

    assert_redirected_to votes_url
  end
end
