class UsersController < ApplicationController
  before_action :only_self, only: [:show]
  before_action :admin_only, only: [:index, :authorize_user, :unauthorize_user, :make_admin, :make_committee, :remove_admin, :remove_committee, :deny_committee]
  before_action :only_approved_users, except: [:show]

  def show
    @user = User.find(params[:id])

    @scholarships = Scholarship.where(user_id: @user.id)
    @hardships = Hardship.where(user_id: @user.id)
    @charities = Charity.where(user_id: @user.id)

    @need_votes = 0
    @scholarship_vote_needed = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided").where.not(user_id: current_user.id)
    @scholarship_vote_needed.each do |app|
      unless Vote.where(application_type: "scholarship", application_id: app.id, user_id: current_user.id).count != 0
        @need_votes += 1
      end
    end
    @hardship_vote_needed = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided").where.not(user_id: current_user.id)
    @hardship_vote_needed.each do |app|
      unless Vote.where(application_type: "hardship", application_id: app.id, user_id: current_user.id).count != 0
        @need_votes += 1
      end
    end
    @charity_vote_needed = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided").where.not(user_id: current_user.id)
    @charity_vote_needed.each do |app|
      unless Vote.where(application_type: "charity", application_id: app.id, user_id: current_user.id).count != 0
        @need_votes += 1
      end
    end

    @questions = Question.where(answered: false)

    @committee_requests = User.where(committee_request: "Requested")

    @testimonials = Testimonial.where(approved: false)

    @open_hardships = Hardship.where(closed: false, status: "Decision Reached")
    @open_scholarships = Scholarship.where(closed: false, status: "Decision Reached")
    @open_charities = Charity.where(closed: false, status: "Decision Reached")
    @open_applications = [@open_scholarships, @open_hardships, @open_charities].flatten

    @open_message_threads = Message.where(issue_closed: false)
  end

  def index
    @users = User.all
    @admin = User.where(admin: true)
    @committee = User.where(committee: true)
    @members = User.where(admin: false, committee: false)
    @committee_requests = User.where(committee_request: "Requested")
    @admin_authorizations = Authorization.where(account_created: false, admin: true)
    @committee_authorizations = Authorization.where(account_created: false, committee: true)
  end

  def only_self
    @user = User.find(params[:id])
    unless current_user && @user.id == current_user.id
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you can only access your own user page."
    end
  end

  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an administrator to access that page."
    end
  end

  def authorize_user
    @user = User.find(params[:id])
    @user.authorized_by_admin = true
    if @user.save!
      Log.create(category: "Admin Action", action: @user.full_name + " Account Authorized", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: users_path)
    flash[:notice] = "That user's account has been authorized."
  end


  def unauthorize_user
    @user = User.find(params[:id])
    @user.authorized_by_admin = false
    if @user.save!
      Log.create(category: "Admin Action", action: @user.full_name + " Account Revoked", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: users_path)
    flash[:notice] = "That user's account has been revoked."
  end

  def make_admin
    @user = User.find(params[:id])
    @user.admin = true
    if @user.save!
      Log.create(category: "Admin Action", action: @user.full_name + " Given Administrator Privileges", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: users_path)
    flash[:notice] = "That user has been made a site administrator."
  end

  def remove_admin
    @user = User.find(params[:id])
    @user.admin = false
    if @user.save
      Log.create(category: "Admin Action", action: @user.full_name + " Administrator Privileges Removed", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: users_path)
    flash[:notice] = "That user's admin privileges have been revoked."
  end

  def make_committee
    @user = User.find(params[:id])
    @user.committee = true
    @user.committee_request = "Approved"
    if @user.save
      Log.create(category: "Admin Action", action: @user.full_name + " Made Committee Member", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: users_path)
    flash[:notice] = "That user has been made a committee member."
  end

  def remove_committee
    @user = User.find(params[:id])
    @user.committee = false
    @user.committee_request = "Removed"
    if @user.save
      Log.create(category: "Admin Action", action: @user.full_name + " Committee Privileges Removed", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: users_path)
    flash[:notice] = "That user's committee privileges have been revoked."
  end

  def committee_request
    @user = User.find(params[:id])
    @user.committee_request = "Requested"
    if @user.save
      Log.create(category: "User Action", action: @user.full_name + " Request to Join Committee", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: user_path(current_user))
    flash[:notice] = "Your request to become a committee member has been successfully sent."
  end

  def deny_committee
    @user = User.find(params[:id])
    @user.committee_request = "Denied"
    if @user.save
      Log.create(category: "Admin Action", action: @user.full_name + " Committee Privileges Denied", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: current_user.id)
    end
    redirect_back(fallback_location: users_path)
    flash[:notice] = "That committee request has been denied."
  end

  def only_approved_users
    unless current_user && current_user.authorized_by_admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you have to wait for your account to be authorized by an administrator to do that.  If it's been more than 24 hours since you registered, feel free to email an admin to check on the status of your application."
    end
  end

end
