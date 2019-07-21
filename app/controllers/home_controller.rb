class HomeController < ApplicationController

  def index
  end

  def pending

    @scholarship_vote_needed = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @scholarship_undecided = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @scholarship_approved = Scholarship.where(status: "Decision Reached", final_decision: "Approved")
    @scholarship_rejected = Scholarship.where(status: "Decision Reached", final_decision: "Rejected")

    @hardship_vote_needed = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @hardship_undecided = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @hardship_approved = Hardship.where(status: "Decision Reached", final_decision: "Approved")
    @hardship_rejected = Hardship.where(status: "Decision Reached", final_decision: "Rejected")

    @charity_vote_needed = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @charity_undecided = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @charity_approved = Charity.where(status: "Decision Reached", final_decision: "Approved")
    @charity_rejected = Charity.where(status: "Decision Reached", final_decision: "Rejected")

    @all_undecided = [@scholarship_vote_needed, @hardship_vote_needed, @charity_vote_needed].flatten
  end

end
