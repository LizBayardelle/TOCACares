class CharitiesController < ApplicationController
  before_action :set_charity, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :already_submitted, only: [:edit, :update]
  before_action :admin_or_committee_only, only: [:index]
  before_action :self_admin_or_committee_if_submitted, only: [:show]
  before_action :committee_only, only: [:approve_charity]

  # GET /charities
  # GET /charities.json
  def index
    @charities = Charity.all
    @vote_needed = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @undecided = Charity.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @approved = Charity.where(status: "Decision Reached", final_decision: "Approved")
    @rejected = Charity.where(status: "Decision Reached", final_decision: "Rejected")
  end

  # GET /charities/1
  # GET /charities/1.json
  def show
  end

  # GET /charities/new
  def new
    @charity = Charity.new
  end

  # GET /charities/1/edit
  def edit
  end

  # POST /charities
  # POST /charities.json
  def create
    @charity = Charity.new(charity_params)
    @charity.user_id = current_user.id
    @charity.status = params[:status]

    respond_to do |format|
      if @charity.save
        if @charity.status == "Submitted to Committee"
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :created, location: @charity }
      else
        format.html { render :new }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /charities/1
  # PATCH/PUT /charities/1.json
  def update
    @charity.status = params[:status]

    respond_to do |format|
      if @charity.update(charity_params)
        if @charity.status == "Submitted to Committee"
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
          format.json { render :show, status: :ok, location: @charity }
      else
        format.html { render :edit }
        format.json { render json: @charity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charities/1
  # DELETE /charities/1.json
  def destroy
    @charity.destroy
    respond_to do |format|
      format.html { redirect_to charities_url, notice: 'Charity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def withdraw_charity
    @charity = Charity.find(params[:id])
    @charity.update_attributes(status: "Withdrawn")
    if @charity.update_attributes(status: "Withdrawn")
        redirect_back(fallback_location: user_path(current_user))
        flash[:notice] = "That application has been withdrawn!"
    else
        redirect_to user_path(current_user)
        flash[:warning] = "Something went wrong.  Please try your request again later."
    end
  end

  def approve_charity
    @charity = Charity.find(params[:id])
    if current_user && @charity.user.id == current_user.id
      redirect_back(fallback_location: charity_path(@charity))
      flash[:warning] = "Sorry, you cannot vote on your own application!"
    else
      if @charity.status == "Submitted to Committee" && ( @charity.final_decision == "Not Decided" || @charity.final_decision == "Modifications Requested" )
        if @charity.approvals.include?(current_user.id.to_s) || @charity.rejections.include?(current_user.id.to_s)
          redirect_back(fallback_location: charity_path(@charity))
          flash[:warning] = "Sorry, you have already voted on that application!"
        else
          if @charity.approvals.count < 1
            @charity.approvals << current_user.id
            @charity.save
            redirect_back(fallback_location: charity_path(@charity))
            flash[:notice] = "You have successfully voted to approve this application."
          elsif @charity.approvals.count >= 1
            @charity.approvals << current_user.id
            @charity.update_attributes(final_decision: "Approved")
            @charity.save
            redirect_back(fallback_location: charity_path(@charity))
            flash[:notice] = "That application has been officially approved!"
          else
            redirect_back(fallback_location: charity_path(@charity))
            flash[:warning] = "Something went wrong.  Please try your request again later."
          end
        end
      end
    end
  end

  def reject_charity
    @charity = Charity.find(params[:id])
    if current_user && @charity.user.id == current_user.id
      redirect_back(fallback_location: charity_path(@charity))
      flash[:warning] = "Sorry, you cannot vote on your own application!"
    else
      if @charity.status == "Submitted to Committee" && ( @charity.final_decision == "Not Decided" || @charity.final_decision == "Modifications Requested" )
        if @charity.rejections.include?(current_user.id.to_s) || @charity.approvals.include?(current_user.id.to_s)
          redirect_back(fallback_location: charity_path(@charity))
          flash[:warning] = "Sorry, you have already voted on that application!"
        else
          if @charity.rejections.count < 1
            @charity.rejections << current_user.id
            @charity.save
            redirect_back(fallback_location: charity_path(@charity))
            flash[:notice] = "You have successfully voted to reject this application."
          elsif @charity.rejections.count >= 1
            @charity.rejections << current_user.id
            @charity.update_attributes(final_decision: "Approved")
            @charity.save
            redirect_back(fallback_location: charity_path(@charity))
            flash[:notice] = "That application has been officially rejected!"
          else
            redirect_back(fallback_location: charity_path(@charity))
            flash[:warning] = "Something went wrong.  Please try your request again later."
          end
        end
      end
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
    # Use callbacks to share common setup or constraints between actions.
    def set_charity
      @charity = Charity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def charity_params
      params.require(:charity).permit(:application_type, :full_name, :date, :position, :branch, :start_date, :email_non_toca, :mobile, :address, :city, :state, :zip, :institution_name, :institution_contact, :institution_phone, :institution_address, :requested_amount, :self_fund, :opportunity_description, :intent_signature, :intent_signature_date, :release_signature, :release_signature_date, :status, :final_decision, :returned, :approvals, :rejections, :user_id)
    end
end
