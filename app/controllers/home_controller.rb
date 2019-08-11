class HomeController < ApplicationController
  before_action :admin_only, only: [:testimonials]

  def index
  end

  def pending
    @scholarship_vote_needed = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided").where.not(id: current_user.id)
    @scholarship_undecided = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @scholarship_approved = Scholarship.where(status: "Decision Reached", final_decision: "Approved")
    @scholarship_rejected = Scholarship.where(status: "Decision Reached", final_decision: "Rejected")

    @hardship_vote_needed = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided").where.not(id: current_user.id)
    @hardship_undecided = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @hardship_approved = Hardship.where(status: "Decision Reached", final_decision: "Approved")
    @hardship_rejected = Hardship.where(status: "Decision Reached", final_decision: "Rejected")

    @charity_vote_needed = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided").where.not(id: current_user.id)
    @charity_undecided = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @charity_approved = Charity.where(status: "Decision Reached", final_decision: "Approved")
    @charity_rejected = Charity.where(status: "Decision Reached", final_decision: "Rejected")

    @all_undecided = [@scholarship_vote_needed, @hardship_vote_needed, @charity_vote_needed].flatten
  end

  def testimonials
    @testimonials = Testimonial.all
    @pending_testimonials = Testimonial.where(approved: false)
    @approved_testimonials = Testimonial.where(approved: true).order(category: :asc).order(created_at: :desc).sort_by { |a| a.featured ? 0 : 1 }
  end


  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an admin to do that."
    end
  end

end
