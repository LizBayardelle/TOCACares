require 'test_helper'

class ValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @value = values(:one)
  end

  test "should get index" do
    get values_url
    assert_response :success
  end

  test "should get new" do
    get new_value_url
    assert_response :success
  end

  test "should create value" do
    assert_difference('Value.count') do
      post values_url, params: { value: { current_year: @value.current_year, individual_contributions: @value.individual_contributions, matching_ratio: @value.matching_ratio, shareholder_matching: @value.shareholder_matching, total_fund_value: @value.total_fund_value } }
    end

    assert_redirected_to value_url(Value.last)
  end

  test "should show value" do
    get value_url(@value)
    assert_response :success
  end

  test "should get edit" do
    get edit_value_url(@value)
    assert_response :success
  end

  test "should update value" do
    patch value_url(@value), params: { value: { current_year: @value.current_year, individual_contributions: @value.individual_contributions, matching_ratio: @value.matching_ratio, shareholder_matching: @value.shareholder_matching, total_fund_value: @value.total_fund_value } }
    assert_redirected_to value_url(@value)
  end

  test "should destroy value" do
    assert_difference('Value.count', -1) do
      delete value_url(@value)
    end

    assert_redirected_to values_url
  end
end
