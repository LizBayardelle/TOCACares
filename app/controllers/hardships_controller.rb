class HardshipsController < ApplicationController
  before_action :set_hardship, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :already_submitted, only: [:edit, :update]
  before_action :admin_or_committee_only, only: [:index]
  before_action :self_admin_or_committee_if_submitted, only: [:show]
  before_action :committee_only, only: [:approve_hardship]


  # GET /hardships
  # GET /hardships.json
  def index
    @hardships = Hardship.all
    @vote_needed = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @undecided = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @approved = Hardship.where(status: "Decision Reached", final_decision: "Approved")
    @rejected = Hardship.where(status: "Decision Reached", final_decision: "Rejected")
  end

  # GET /hardships/1
  # GET /hardships/1.json
  def show
    @new_modification = Modification.new
    @modifications = Modification.where(app_type: "hardship", app_id: @hardship.id, superseded: false)
  end

  # GET /hardships/new
  def new
    @hardship = Hardship.new
  end

  # GET /hardships/1/edit
  def edit
  end

  # POST /hardships
  # POST /hardships.json
  def create
    @hardship = Hardship.new(hardship_params)
    @hardship.user_id = current_user.id
    @hardship.status = params[:status]
    @hardship.application_type = "hardship"

    respond_to do |format|
      if @hardship.save
        if @hardship.status == "Submitted to Committee"
          NewApplicationMailer.send_new_application_email(@hardship).deliver
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :created, location: @hardship }
      else
        format.html { render :new }
        format.json { render json: @hardship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hardships/1
  # PATCH/PUT /hardships/1.json
  def update
    @hardship.status = params[:status]

    respond_to do |format|
      if @hardship.update(hardship_params)
        if @hardship.status == "Submitted to Committee"
          NewApplicationMailer.send_new_application_email(@hardship).deliver
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
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
      format.html { redirect_to hardships_url, notice: 'Your application has been successfully deleted.' }
      format.json { head :no_content }
    end
  end




  def withdraw_hardship
    @hardship = Hardship.find(params[:id])
    @hardship.update_attributes(status: "Withdrawn")
    if @hardship.update_attributes(status: "Withdrawn")
        redirect_back(fallback_location: user_path(current_user))
        flash[:notice] = "That application has been withdrawn!"
    else
        redirect_to user_path(current_user)
        flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end




  def approve_hardship
    @hardship = Hardship.find(params[:id])
    if current_user && @hardship.user.id == current_user.id
      redirect_back(fallback_location: hardship_path(@hardship))
      flash[:warning] = "Sorry, you cannot vote on your own application!"
    else
      if @hardship.status == "Submitted to Committee" && ( @hardship.final_decision == "Not Decided" || @hardship.final_decision == "Modifications Requested" )
        if @hardship.approvals.include?(current_user.id.to_s) || @hardship.rejections.include?(current_user.id.to_s)
          redirect_back(fallback_location: hardship_path(@hardship))
          flash[:warning] = "Sorry, you have already voted on that application!"
        else
          if @hardship.approvals.count < 1
            @hardship.approvals << current_user.id
            @hardship.save
            redirect_back(fallback_location: hardship_path(@hardship))
            flash[:notice] = "You have successfully voted to approve this application."
          elsif @hardship.approvals.count >= 1
            @hardship.approvals << current_user.id
            @hardship.update_attributes(status: "Decision Reached", final_decision: "Approved", approved: true)
            @hardship.save
            if @hardship.for_other
              # transfer ownership of application to recipient
              # send email to submitting member
              HardshipMailer.by_other_hardship_accepted_email(@hardship).deliver
            else
              HardshipMailer.hardship_accepted_email(@hardship).deliver
            end
            redirect_back(fallback_location: hardship_path(@hardship))
            flash[:notice] = "That application has been officially approved!"
          else
            redirect_back(fallback_location: hardship_path(@hardship))
            flash[:warning] = "Something went wrong.  Please try your request again later."
          end
        end
      end
    end
  end

  def reject_hardship
    @hardship = Hardship.find(params[:id])
    if current_user && @hardship.user.id == current_user.id
      redirect_back(fallback_location: hardship_path(@hardship))
      flash[:warning] = "Sorry, you cannot vote on your own application!"
    else
      if @hardship.status == "Submitted to Committee" && ( @hardship.final_decision == "Not Decided" || @hardship.final_decision == "Modifications Requested" )
        if @hardship.rejections.include?(current_user.id.to_s) || @hardship.approvals.include?(current_user.id.to_s)
          redirect_back(fallback_location: hardship_path(@hardship))
          flash[:warning] = "Sorry, you have already voted on that application!"
        else
          if @hardship.rejections.count < 1
            @hardship.rejections << current_user.id
            @hardship.save
            redirect_back(fallback_location: hardship_path(@hardship))
            flash[:notice] = "You have successfully voted to reject this application."
          elsif @hardship.rejections.count >= 1
            @hardship.rejections << current_user.id
            @hardship.update_attributes(status: "Decision Reached", final_decision: "Denied", denied: true)
            @hardship.save
            if @hardship.for_other
              #send email to submitting member
            else
              #send rejection email to applicant
            end
            redirect_back(fallback_location: hardship_path(@hardship))
            flash[:notice] = "That application has been officially denied!"
          else
            redirect_back(fallback_location: hardship_path(@hardship))
            flash[:warning] = "Something went wrong.  Please try your request again later."
          end
        end
      end
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

    # Use callbacks to share common setup or constraints between actions.
    def set_hardship
      @hardship = Hardship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardship_params
      params.require(:hardship).permit(
        :user_id,
        :application_type,

        :loan_preferred,

        :for_other,
        :for_other_email,

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
        :final_decision
      )
    end
end
