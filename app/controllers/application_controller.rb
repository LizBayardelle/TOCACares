class ApplicationController < ActionController::Base
  before_action :set_values

  def set_values
    @current_value = Value.where(selected: true).first
    @current_year = @current_value.current_year
    @matching_ratio = @current_value.matching_ratio
    @individual_contributions = @current_value.individual_contributions
    @shareholder_matching = @current_value.shareholder_matching
    @total_fund_value = @current_value.total_fund_value
    @new_question = Question.new
  end
end
