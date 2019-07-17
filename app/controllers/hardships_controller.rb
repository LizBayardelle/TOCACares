class HardshipsController < ApplicationController
  before_action :set_hardship, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :already_submitted, only: [:edit, :update]
  before_action :admin_only, only: [:index]
  before_action :self_admin_or_committee_if_submitted, only: [:show]


  # GET /hardships
  # GET /hardships.json
  def index
    @hardships = Hardship.all
    @undecided = Hardship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @approved = Hardship.where(status: "Decision Reached", final_decision: "Approved")
    @rejected = Hardship.where(status: "Decision Reached", final_decision: "Rejected")
  end

  # GET /hardships/1
  # GET /hardships/1.json
  def show

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

    respond_to do |format|
      if @hardship.save
        if @hardship.status == "Submitted to Committee"
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

  # DELETE /hardships/1
  # DELETE /hardships/1.json
  def destroy
    @hardship.destroy
    respond_to do |format|
      format.html { redirect_to hardships_url, notice: 'Your application has been successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def withdraw_application
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

  def already_submitted
    if @hardship.status == "Submitted to Committee" || @hardship.status == "Final Decision Reached"
      redirect_back(fallback_location: user_path(current_user))
      flash[:warning] = "Sorry, you can't edit an application that's already been submitted."
    end
  end

  def admin_only
    unless current_user && current_user.admin
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
        :status,
        :review_first_status,
        :review_first_reviewer_id,
        :review_second,
        :review_second_reviewer_id,
        :final_decision,
        :user_id
      )
    end
end
