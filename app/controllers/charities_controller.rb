class CharitiesController < ApplicationController
  before_action :set_charity, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :already_submitted, only: [:edit, :update]
  before_action :admin_or_committee_only, only: [:index]
  before_action :self_admin_or_committee_if_submitted, only: [:show]
  before_action :admin_only, only: [:funding_completed_charity, :close_charity]




  def index
    @charities = Charity.all
    @vote_needed = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @undecided = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @approved = Charity.where(status: "Decision Reached", final_decision: "Approved")
    @rejected = Charity.where(status: "Decision Reached", final_decision: "Rejected")
  end



  def show
    @new_vote = Vote.new
    @votes = Vote.where(application_type: "charity", application_id: @charity.id)
    @votes_accept = Vote.where(accept: true, application_type: "charity", application_id: @charity.id, superseded: false)
    @votes_modify = Vote.where(modify: true, application_type: "charity", application_id: @charity.id, superseded: false)
    @votes_deny = Vote.where(deny: true, application_type: "charity", application_id: @charity.id, superseded: false)
  end



  def new
    @charity = Charity.new
  end



  def edit
    @votes = Vote.where(application_type: "charity", application_id: @charity.id, seconded: true)
  end



  def create
    @charity = Charity.new(charity_params)
    @charity.user_id = current_user.id
    @charity.status = params[:status]
    @charity.application_type = "charity"

    respond_to do |format|
      if @charity.save
        if @charity.status == "Submitted to Committee"
          Log.create(category: "User Action", action: "Charity Application Submitted", automatic: false, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: true, user_id: @charity.user.id)
          if ApplicationChangeMailer.new_application_email(@charity).deliver
            Log.create(category: "Email", action: "New Charity Application Email Sent to Committee", automatic: true, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: false)
          end
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          Log.create(category: "User Action", action: "Charity Application Created", automatic: false, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: true, user_id: @charity.user.id)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :created, location: @charity }
      else
        format.html { render :new }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
      end
    end
  end



  def update
    @charity.status = params[:status]

    respond_to do |format|
      if @charity.update(charity_params)
        if @charity.status == "Submitted to Committee"
          @votes = Vote.where(application_type: @charity.application_type, application_id: @charity.id)
          @votes.each(&:destroy)
          Log.create(category: "User Action", action: "Charity Application Submitted", automatic: false, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: true, user_id: @charity.user.id)
          if ApplicationChangeMailer.new_application_email(@charity).deliver
            Log.create(category: "Email", action: "New Charity Application Email Sent to Committee", automatic: true, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: false)
          end
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          Log.create(category: "User Action", action: "Charity Application Updated", automatic: false, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: true, user_id: @charity.user.id)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :ok, location: @charity }
      else
        format.html { render :edit }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    @charity.destroy
    respond_to do |format|
      Log.create(category: "User Action", action: "Charity Application Deleted", automatic: false, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: true, user_id: @charity.user.id)
      format.html { redirect_to charities_url, notice: 'That application has been successfully deleted.' }
      format.json { head :no_content }
    end
  end



  def withdraw_charity
    @charity = Charity.find(params[:id])
    @charity.update_attributes(status: "Withdrawn")
    if @charity.update_attributes(status: "Withdrawn")
      Log.create(category: "User Action", action: "Charity Application Withdrawn", automatic: false, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: true, user_id: @charity.user.id)
      redirect_back(fallback_location: user_path(current_user))
      flash[:notice] = "That application has been withdrawn!"
    else
      redirect_to user_path(current_user)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def funding_completed_charity
    @charity = Charity.find(params[:id])
    @charity.update_attributes(funding_status: "Funding Completed")
    if @charity.update_attributes(funding_status: "Funding Completed")
      Log.create(category: "Admin Action", action: "Charity Application Funding Marked Complete", automatic: false, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: true)
      if ApplicationChangeMailer.funding_completed_email(@charity).deliver
        Log.create(category: "Email", action: "Charity Application Funding Completed Email Sent to Applicant", automatic: true, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: false)
      end
      redirect_back(fallback_location: home_applications_path)
      flash[:notice] = "The funding status for that application has been updated!"
    else
        redirect_to user_path(current_user)
        flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def close_charity
    @charity = Charity.find(params[:id])
    @charity.update_attributes(closed: true)
    if @charity.update_attributes(closed: true)
      Log.create(category: "Admin Action", action: "Charity Application Funding Marked Closed", automatic: false, object: true, object_linkable: true, object_category: "charity", object_id: @charity.id, taken_by_user: true)
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
    if @charity.status == "Submitted to Committee" || @charity.status == "Final Decision Reached"
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
    unless (@charity.user.id == current_user.id) || (current_user.admin) || (current_user.committee && ( @charity.status == "Submitted to Committee" || @charity.status == "Decision Reached" ))
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you cannot view that application at this time.  If you believe you have gotten this message in error, please contact the system administrator at admin@tocacares.com."
    end
  end



  private



  def set_charity
    @charity = Charity.find(params[:id])
  end



  def charity_params
    params.require(:charity).permit(
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
      :opportunity_description,
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
