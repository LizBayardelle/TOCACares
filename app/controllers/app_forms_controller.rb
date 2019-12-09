class AppFormsController < ApplicationController
  before_action :set_app_form, only: [:show, :edit, :update, :destroy]
  after_action :empty_string_to_nil, only: [:update, :create]
  before_action :admin_or_committee_only, only: [:index]




  def index
    @app_forms = AppForm.all
    @all_open = AppForm.where(closed: false, submitted: true)
    @all_closed = AppForm.where(closed: true)
    @open = AppForm.where(submitted: true, closed: false).order("created_at DESC")
    @active = AppForm.where(submitted: true, closed: false, final_decision_id: 1).order("created_at DESC")
    @returned_for_modifications = AppForm.where(closed: false, application_status_id: 4).order("created_at DESC")
    @abandoned = AppForm.where(submitted: false, closed: false).where("updated_at < ?", 30.days.ago).order("created_at DESC")
    @decided = AppForm.where(closed: false, application_status_id: 5).order("created_at DESC")
    @funded_and_closed = AppForm.where(closed: true, funding_status_id: 3).order("created_at DESC")
    @declined_and_closed = AppForm.where(closed: true, application_status_id: 5, final_decision_id: 2).order("created_at DESC")
    @abandoned_and_closed = AppForm.where(closed: true).where.not(application_status_id: 5).order("created_at DESC")
  end




  def show
    @new_vote = Vote.new
    @votes = Vote.where(application_type: "AppForm", application_id: @app_form.id)
    @votes_accept = Vote.where(accept: true, application_type: "AppForm", application_id: @app_form.id, superseded: false)
    @votes_modify = Vote.where(modify: true, application_type: "AppForm", application_id: @app_form.id, superseded: false)
    @votes_deny = Vote.where(deny: true, application_type: "AppForm", application_id: @app_form.id, superseded: false)
    @messages = Message.where(ref_application_type: "AppForm", ref_application_id: @app_form.id)
    @seconded_vote = Vote.where(application_type: "AppForm", application_id: @app_form.id, seconded: true).first
  end




  def new
    @app_form = AppForm.new
  end




  def edit
  end



  def create
    @app_form = AppForm.new(app_form_params)
    @app_form.user_id = current_user.id
    @app_form.application_status_id = params[:application_status_id]
    @app_form.final_decision_id = 1
    @app_form.funding_status_id = 1
    if @app_form.date == nil
      @app_form.date = Date.today
    end
    if @app_form.application_status_id == 3
      @app_form.submitted = true
    end

    respond_to do |format|
      if @app_form.save
        if @app_form.application_status_id == 3
          Log.create(category: "User Action", action: "New Application Submitted", automatic: false, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: true, user_id: @app_form.user.id)
          if ApplicationChangeMailer.new_application_email(@app_form).deliver
            Log.create(category: "Email", action: "New Application Email Sent to Committee", automatic: true, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: false)
          end
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          Log.create(category: "User Action", action: "New Application Created", automatic: false, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: true, user_id: @app_form.user.id)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :created, location: @app_form }
      else
        format.html { render :new }
        format.json { render json: @app_form.errors, status: :unprocessable_entity }
      end
    end
  end




  def update
    @app_form.application_status_id = params[:application_status_id]
    if @app_form.application_status_id == 3
      @app_form.submitted = true
    end

    respond_to do |format|
      if @app_form.update(app_form_params)
        if @app_form.application_status_id == 3
          @votes = Vote.where(application_type: @app_form.application_type, application_id: @app_form.id)
          @votes.each(&:destroy)
          Log.create(category: "User Action", action: "Application Submitted", automatic: false, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: true, user_id: @app_form.user.id)
          if ApplicationChangeMailer.new_application_email(@app_form).deliver
            Log.create(category: "Email", action: "New Application Email Sent to Committee", automatic: true, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: false)
          end
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          Log.create(category: "User Action", action: "Application Updated", automatic: false, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: true, user_id: @app_form.user.id)
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :ok, location: @app_form }
      else
        format.html { render :edit }
        format.json { render json: @app_form.errors, status: :unprocessable_entity }
      end
    end
  end




  def destroy
    @app_form.destroy
    respond_to do |format|
      format.html { redirect_to app_forms_url, notice: 'App form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end





  def withdraw_app_form
    @app_form = AppForm.find(params[:id])
    if @app_form.update_attributes(application_status_id: 6, final_decision_id: 6)
        redirect_back(fallback_location: user_path(current_user))
        Log.create(category: "User Action", action: "Application Withdrawn", automatic: false, object: true, object_category: "app_form", object_id: @app_form.id, taken_by_user: true, user_id: @app_form.user.id)
        flash[:notice] = "That application has been withdrawn!"
    else
        redirect_to user_path(current_user)
        flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end




  def funding_completed
    @app_form = AppForm.find(params[:id])
    @app_form.update_attributes(funding_status_id: 3)
    if @app_form.update_attributes(funding_status_id: 3)
      Log.create(category: "Admin Action", action: "Application Funding Marked Complete", automatic: false, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: true)
      if ApplicationChangeMailer.funding_completed_email(@app_form).deliver
        Log.create(category: "Email", action: "Application Funding Completed Email Sent to Applicant", automatic: true, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: false)
      end
      redirect_back(fallback_location: app_forms_path)
      flash[:notice] = "The funding status for that application has been updated!"
    else
      redirect_to user_path(current_user)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def close_application
    @app_form = AppForm.find(params[:id])
    @app_form.update_attributes(closed: true)
    if @app_form.update_attributes(closed: true)
      Log.create(category: "Admin Action", action: "Application Funding Marked Closed", automatic: false, object: true, object_linkable: true, object_category: "AppForm", object_id: @app_form.id, taken_by_user: true)
      redirect_back(fallback_location: user_path(current_user))
      flash[:notice] = "That application has been closed!"
    else
      redirect_to user_path(current_user)
      flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end



  def empty_string_to_nil

    if @app_form.for_other_email == ""
      @app_form.for_other_email = nil
    end
    if @app_form.recipient_toca_email == ""
      @app_form.recipient_toca_email = nil
    end
    if @app_form.loan_preferred_description == ""
      @app_form.loan_preferred_description = nil
    end
    if @app_form.bank_name == ""
      @app_form.bank_name = nil
    end
    if @app_form.bank_phone == ""
      @app_form.bank_phone = nil
    end
    if @app_form.bank_address == ""
      @app_form.bank_address = nil
    end
    if @app_form.institution_contact == ""
      @app_form.institution_contact = nil
    end
    if @app_form.institution_name == ""
      @app_form.institution_name = nil
    end
    if @app_form.institution_phone == ""
      @app_form.institution_phone = nil
    end
    if @app_form.institution_address == ""
      @app_form.institution_address = nil
    end
  end




  def admin_or_committee_only
    unless current_user && ( current_user.admin || current_user.committee )
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be an administrator or committee member to access that page."
    end
  end







  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_form
      @app_form = AppForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_form_params
      params.require(:app_form).permit(
        :application_type,

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

        :for_other,
        :for_other_email,
        :recipient_toca_email,

        :transfer_pending,
        :bank_name,
        :bank_phone,
        :bank_address,

        :institution_name,
        :institution_contact,
        :institution_phone,
        :institution_address,

        :requested_amount,
        :self_fund,
        :loan_preferred,
        :loan_preferred_description,

        :description,
        :accident,
        :catastrophe,
        :counseling,
        :family_emergency,
        :health,
        :memorial,
        :other_hardship,
        :other_hardship_description,

        :intent_signature,
        :intent_signature_date,
        :release_signature,
        :release_signature_date,

        :submitted,
        :approved,
        :denied,
        :returned,
        :closed,

        :application_status_id,
        :final_decision_id,
        :funding_status_id,
        :user_id
      )
    end
end
