class HomeController < ApplicationController
  before_action :admin_only, only: [:testimonials]

  def index
    @question = Question.new
  end

  def testimonials
    @testimonials = Testimonial.all
    @pending_testimonials = Testimonial.where(approved: false)
    @approved_testimonials = Testimonial.where(approved: true).order(category: :asc).order(created_at: :desc).sort_by { |a| a.featured ? 0 : 1 }
  end

  def applications
    @hardships = Hardship.where(closed: false, status: "Submitted to Committee").or(Hardship.where(closed: false, status: "Decision Reached")).or(Hardship.where(closed: false, status: "Returned for Modifications"))
    @scholarships = Scholarship.where(closed: false, status: "Submitted to Committee").or(Scholarship.where(closed: false, status: "Decision Reached")).or(Scholarship.where(closed: false, status: "Returned for Modifications"))
    @charities = Charity.where(closed: false, status: "Submitted to Committee").or(Charity.where(closed: false, status: "Decision Reached")).or(Charity.where(closed: false, status: "Returned for Modifications"))
    @open_applications = [@scholarships, @hardships, @charities].flatten

    @closed_hardships = Hardship.where(closed: true)
    @closed_scholarships = Scholarship.where(closed: true)
    @closed_charities = Charity.where(closed: true)
    @closed_applications = [@closed_scholarships, @closed_hardships, @closed_charities].flatten
  end


  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an admin to do that."
    end
  end

end
