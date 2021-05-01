class ScholarshipsController < ApplicationController
  before_action :set_scholarship, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :already_submitted, only: [:edit, :update]
  before_action :admin_or_committee_only, only: [:index]
  before_action :self_admin_or_committee_if_submitted, only: [:show]
  before_action :admin_only, only: [:funding_completed_scholarship, :close_scholarship]
  before_action :only_approved_users




  def index
    @scholarships = Scholarship.all
    @vote_needed = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @undecided = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @approved = Scholarship.where(status: "Decision Reached", final_decision: "Approved")
    @rejected = Scholarship.where(status: "Decision Reached", final_decision: "Rejected")
  end



  def show
    @new_vote = Vote.new
    @votes = Vote.where(application_type: "scholarship", application_id: @scholarship.id)
    @votes_accept = Vote.where(accept: true, application_type: "scholarship", application_id: @scholarship.id, superseded: false)
    @votes_modify = Vote.where(modify: true, application_type: "scholarship", application_id: @scholarship.id, superseded: false)
    @votes_deny = Vote.where(deny: true, application_type: "scholarship", application_id: @scholarship.id, superseded: false)
    @messages = Message.where(ref_application_type: "scholarship", ref_application_id: @scholarship.id)
    @seconded_vote = Vote.where(application_type: "scholarship", application_id: @scholarship.id, seconded: true).first
  end



  def new
    @scholarship = Scholarship.new
  end



  def edit
    @votes = Vote.where(application_type: "scholarship", application_id: @scholarship.id, seconded: true)
  end



  def create
    @scholarship = Scholarship.new(scholarship_params)
    @scholarship.user_id = current_user.id
    @scholarship.status = params[:status]
    @scholarship.application_type = "scholarship"

    respond_to do |format|
      if @scholarship.save
        if @scholarship.status == "Submitted to Committee"
          Log.create(category: "User Action", action: "Scholarship Application Submitted", automatic: false, object: true, object_linkable: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: true, user_id: @scholarship.user.id)
          if ApplicationChangeMailer.new_application_email(@scholarship).deliver
            Log.create(category: "Email", action: "New Scholarship Application Email Sent to Committee", automatic: true, object: true, object_linkable: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: false)
          end
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          Log.create(category: "User Action", action: "Scholarship Application Created", automatic: false, object: true, object_linkable: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: true, user_id: @scholarship.user.id)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :created, location: @scholarship }
      else
        format.html { render :new }
        format.json { render json: @scholarship.errors, status: :unprocessable_entity }
      end
    end
  end



  def update
    @scholarship.status = params[:status]

    respond_to do |format|
      if @scholarship.update(scholarship_params)
        if @scholarship.status == "Submitted to Committee"
          @votes = Vote.where(application_type: @scholarship.application_type, application_id: @scholarship.id)
          @votes.each(&:destroy)
          Log.create(category: "User Action", action: "Scholarship Application Submitted", automatic: false, object: true, object_linkable: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: true, user_id: @hardship.user.id)
          if ApplicationChangeMailer.new_application_email(@scholarship).deliver
            Log.create(category: "Email", action: "New Scholarship Application Email Sent to Committee", automatic: true, object: true, object_linkable: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: false)
          end
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          Log.create(category: "User Action", action: "Scholarship Application Updated", automatic: false, object: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: true, user_id: @scholarship.user.id)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :ok, location: @scholarship }
      else
        format.html { render :edit }
        format.json { render json: @scholarship.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    @scholarship.destroy
    respond_to do |format|
      Log.create(category: "User Action", action: "Scholarship Application Deleted", automatic: false, object: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: true, user_id: @scholarship.user.id)
      format.html { redirect_to scholarships_url, notice: 'That application has been successfully deleted.' }
      format.json { head :no_content }
    end
  end



  def withdraw_scholarship
    @scholarship = Scholarship.find(params[:id])
    if @scholarship.update_attributes(status: "Withdrawn", final_decision: "Withdrawn by Applicant")
        redirect_back(fallback_location: user_path(current_user))
        Log.create(category: "User Action", action: "Scholarship Application Withdrawn", automatic: false, object: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: true, user_id: @scholarship.user.id)
        flash[:notice] = "That application has been withdrawn!"
    else
        redirect_to user_path(current_user)
        flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def funding_completed_scholarship
    @scholarship = Scholarship.find(params[:id])
    @scholarship.update_attributes(funding_status: "Funding Completed")
    if @scholarship.update_attributes(funding_status: "Funding Completed")
      Log.create(category: "Admin Action", action: "Scholarship Application Funding Marked Complete", automatic: false, object: true, object_linkable: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: true)
      if ApplicationChangeMailer.funding_completed_email(@scholarship).deliver
        Log.create(category: "Email", action: "Scholarship Application Funding Completed Email Sent to Applicant", automatic: true, object: true, object_linkable: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: false)
      end
      redirect_back(fallback_location: home_applications_path)
      flash[:notice] = "The funding status for that application has been updated!"
    else
      redirect_to user_path(current_user)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def close_scholarship
    @scholarship = Scholarship.find(params[:id])
    @scholarship.update_attributes(closed: true)
    if @scholarship.update_attributes(closed: true)
      Log.create(category: "Admin Action", action: "Scholarship Application Funding Marked Closed", automatic: false, object: true, object_linkable: true, object_category: "scholarship", object_id: @scholarship.id, taken_by_user: true)
      redirect_back(fallback_location: user_path(current_user))
      flash[:notice] = "That application has been closed!"
    else
      redirect_to user_path(current_user)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def admin_only
    unless current_user && current_user.admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an admin to do that."
    end
  end



  def already_submitted
    if @scholarship.status == "Submitted to Committee" || @scholarship.status == "Final Decision Reached"
      redirect_back(fallback_location: user_path(current_user))
      flash[:warning] = "Sorry, you can't edit an application that's already been submitted."
    end
  end



  def committee_only
    unless current_user && current_user.committee
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be a committee member to do that."
    end
  end



  def admin_or_committee_only
    unless current_user && ( current_user.admin || current_user.committee )
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an administrator to access that page."
    end
  end



  def self_admin_or_committee_if_submitted
    unless current_user && (@scholarship.user.id == current_user.id) || (current_user.admin) || (current_user.committee && ( @scholarship.status == "Submitted to Committee" || @scholarship.status == "Decision Reached" ))
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you cannot view that application at this time.  If you believe you have gotten this message in error, please contact the system administrator at support@tocacares.com."
    end
  end



  def only_approved_users
    unless current_user && current_user.authorized_by_admin
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you have to wait for your account to be authorized by an administrator to do that.  If it's been more than 24 hours since you registered, feel free to email an admin to check on the status of your application."
    end
  end



  private



  def set_scholarship
    @scholarship = Scholarship.find(params[:id])
  end



  def scholarship_params
    params.require(:scholarship).permit(
      :user_id,
      :application_type,

      :loan_preferred,

      :full_name,
      :date,
      :position,
      :branch,
      :start_date,
      :email_non_toca,
      :mobile,
      :address,
      :city,
      :state,
      :zip,

      :institution_name,
      :institution_contact,
      :institution_phone,
      :institution_address,

      :requested_amount,
      :self_fund,

      :scholarship_description,

      :intent_signature,
      :intent_signature_date,
      :release_signature,
      :release_signature_date,

      :approved,
      :returned,
      :denied,
      :closed,

      :status,
      :funding_status,
      :final_decision
    )
  end
end
