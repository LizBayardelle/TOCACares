class HardshipsController < ApplicationController
  before_action :set_hardship, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :already_submitted, only: [:edit, :update]
  before_action :admin_or_committee_only, only: [:index]
  before_action :self_admin_or_committee_if_submitted, only: [:show]
  before_action :admin_only, only: [:funding_completed_hardship, :close_hardship]




  def index
    @hardships = Hardship.all
    @vote_needed = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @undecided = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @approved = Hardship.where(status: "Decision Reached", final_decision: "Approved")
    @rejected = Hardship.where(status: "Decision Reached", final_decision: "Rejected")
  end



  def show
    @new_vote = Vote.new
    @votes = Vote.where(application_type: "hardship", application_id: @hardship.id, seconded: true)
    @votes_accept = Vote.where(accept: true, application_type: "hardship", application_id: @hardship.id, superseded: false)
    @votes_modify = Vote.where(modify: true, application_type: "hardship", application_id: @hardship.id, superseded: false)
    @votes_deny = Vote.where(deny: true, application_type: "hardship", application_id: @hardship.id, superseded: false)
  end



  def new
    @hardship = Hardship.new
  end



  def edit
    @votes = Vote.where(application_type: "hardship", application_id: @hardship.id, seconded: true)
  end



  def create
    @hardship = Hardship.new(hardship_params)
    @hardship.user_id = current_user.id
    @hardship.status = params[:status]
    @hardship.application_type = "hardship"

    respond_to do |format|
      if @hardship.save
        if @hardship.status == "Submitted to Committee"
          Log.create(category: "User Action", action: "Hardship Application Submitted", automatic: false, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: true, user_id: @hardship.user.id)
          ApplicationChangeMailer.new_application_email(@hardship).deliver
          Log.create(category: "Email", action: "New Hardship Application Email Sent to Committee", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: false)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          Log.create(category: "User Action", action: "Hardship Application Created", automatic: false, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: true, user_id: @hardship.user.id)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :created, location: @hardship }
      else
        format.html { render :new }
        format.json { render json: @hardship.errors, status: :unprocessable_entity }
      end
    end
  end



  def update
    @hardship.status = params[:status]

    respond_to do |format|
      if @hardship.update(hardship_params)
        if @hardship.status == "Submitted to Committee"
          @votes = Vote.where(application_type: @hardship.application_type, application_id: @hardship.id)
          @votes.each(&:destroy)
          Log.create(category: "User Action", action: "Hardship Application Submitted", automatic: false, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: true, user_id: @hardship.user.id)
          ApplicationChangeMailer.new_application_email(@hardship).deliver
          Log.create(category: "Email", action: "New Hardship Application Email Sent to Committee", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: false)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          Log.create(category: "User Action", action: "Hardship Application Updated", automatic: false, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: true, user_id: @hardship.user.id)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :ok, location: @hardship }
      else
        format.html { render :edit }
        format.json { render json: @hardship.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    @hardship.destroy
    respond_to do |format|
      Log.create(category: "User Action", action: "Hardship Application Deleted", automatic: false, object: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: true, user_id: @hardship.user.id)
      format.html { redirect_to hardships_url, notice: 'That application has been successfully deleted.' }
      format.json { head :no_content }
    end
  end



  def withdraw_hardship
    @hardship = Hardship.find(params[:id])
    @hardship.update_attributes(status: "Withdrawn")
    if @hardship.update_attributes(status: "Withdrawn")
      Log.create(category: "User Action", action: "Hardship Application Withdrawn", automatic: false, object: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: true, user_id: @hardship.user.id)
      redirect_back(fallback_location: user_path(current_user))
      flash[:notice] = "That application has been withdrawn!"
    else
      redirect_to user_path(current_user)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def funding_completed_hardship
    @hardship = Hardship.find(params[:id])
    @hardship.update_attributes(funding_status: "Funding Completed")
    if @hardship.update_attributes(funding_status: "Funding Completed")
      Log.create(category: "Admin Action", action: "Hardship Application Funding Marked Complete", automatic: false, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: true)
      ApplicationChangeMailer.funding_completed_email(@hardship).deliver
      Log.create(category: "Email", action: "Hardship Application Funding Completed Email Sent to Applicant", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: false)
      redirect_back(fallback_location: home_applications_path)
      flash[:notice] = "The funding status for that application has been updated!"
    else
      redirect_to user_path(current_user)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def close_hardship
    @hardship = Hardship.find(params[:id])
    @hardship.update_attributes(closed: true)
    if @hardship.update_attributes(closed: true)
      Log.create(category: "Admin Action", action: "Hardship Application Funding Marked Closed", automatic: false, object: true, object_linkable: true, object_category: "hardship", object_id: @hardship.id, taken_by_user: true)
      redirect_back(fallback_location: home_applications_path)
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
    if @hardship.status == "Submitted to Committee" || @hardship.status == "Final Decision Reached"
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
    unless current_user && (@hardship.user.id == current_user.id) || (current_user.admin) || (current_user.committee && ( @hardship.status == "Submitted to Committee" || @hardship.status == "Decision Reached" ))
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you cannot view that application at this time.  If you believe you have gotten this message in error, please contact the system administrator at admin@tocacares.com."
    end
  end



  private



  def set_hardship
    @hardship = Hardship.find(params[:id])
  end



  def hardship_params
    params.require(:hardship).permit(
      :user_id,
      :application_type,

      :loan_preferred,

      :for_other,
      :for_other_email,
      :recipient_toca_email,
      :transfer_pending,

      :full_name,
      :date,
      :position,
      :branch,
      :email_non_toca,
      :mobile,
      :address,
      :city,
      :state,
      :zip,
      :bank_name,
      :bank_phone,
      :bank_address,
      :start_date,
      :accident,
      :catastrophe,
      :counseling,
      :family_emergency,
      :health,
      :memorial,
      :other_hardship,
      :other_hardship_description,
      :requested_amount,
      :hardship_description,
      :self_fund,
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
