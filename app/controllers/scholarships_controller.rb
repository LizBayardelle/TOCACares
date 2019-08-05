class ScholarshipsController < ApplicationController
  before_action :set_scholarship, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :already_submitted, only: [:edit, :update]
  before_action :admin_or_committee_only, only: [:index]
  before_action :self_admin_or_committee_if_submitted, only: [:show]
  before_action :committee_only, only: [:approve_scholarship]

  # GET /scholarships
  # GET /scholarships.json
  def index
    @scholarships = Scholarship.all
    @vote_needed = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @undecided = Scholarship.where(status: "Submitted to Committee", final_decision: "Not Decided")
    @approved = Scholarship.where(status: "Decision Reached", final_decision: "Approved")
    @rejected = Scholarship.where(status: "Decision Reached", final_decision: "Rejected")
  end

  # GET /scholarships/1
  # GET /scholarships/1.json
  def show
    @new_modification = Modification.new
    @modifications = Modification.where(app_type: "scholarship", app_id: @scholarship.id, superseded: false)
  end

  # GET /scholarships/new
  def new
    @scholarship = Scholarship.new
  end

  # GET /scholarships/1/edit
  def edit
  end

  # POST /scholarships
  # POST /scholarships.json
  def create
    @scholarship = Scholarship.new(scholarship_params)
    @scholarship.user_id = current_user.id
    @scholarship.status = params[:status]
    @scholarship.application_type = "scholarship"

    respond_to do |format|
      if @scholarship.save
        if @scholarship.status == "Submitted to Committee"
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
        format.json { render :show, status: :created, location: @scholarship }
      else
        format.html { render :new }
        format.json { render json: @scholarship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scholarships/1
  # PATCH/PUT /scholarships/1.json
  def update
    @scholarship.status = params[:status]

    respond_to do |format|
      if @scholarship.update(scholarship_params)
        if @scholarship.status == "Submitted to Committee"
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully submitted.  You will receive an email when the committee reaches a decision.' }
        else
          format.html { redirect_to user_path(current_user), notice: 'Your application has been successfully saved.  It will not be reviewed until you submit it for consideration.' }
        end
          format.json { render :show, status: :ok, location: @scholarship }
      else
        format.html { render :edit }
        format.json { render json: @scholarship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scholarships/1
  # DELETE /scholarships/1.json
  def destroy
    @scholarship.destroy
    respond_to do |format|
      format.html { redirect_to scholarships_url, notice: 'Scholarship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


    def withdraw_scholarship
      @scholarship = Scholarship.find(params[:id])
      @scholarship.update_attributes(status: "Withdrawn")
      if @scholarship.update_attributes(status: "Withdrawn")
          redirect_back(fallback_location: user_path(current_user))
          flash[:notice] = "That application has been withdrawn!"
      else
          redirect_to user_path(current_user)
          flash[:warning] = "Something went wrong.  Please try your request again later."
      end
    end

    def approve_scholarship
      @scholarship = Scholarship.find(params[:id])
      if current_user && @scholarship.user.id == current_user.id
        redirect_back(fallback_location: scholarship_path(@scholarship))
        flash[:warning] = "Sorry, you cannot vote on your own application!"
      else
        if @scholarship.status == "Submitted to Committee" && ( @scholarship.final_decision == "Not Decided" || @scholarship.final_decision == "Modifications Requested" )
          if @scholarship.approvals.include?(current_user.id.to_s) || @scholarship.rejections.include?(current_user.id.to_s)
            redirect_back(fallback_location: scholarship_path(@scholarship))
            flash[:warning] = "Sorry, you have already voted on that application!"
          else
            if @scholarship.approvals.count < 1
              @scholarship.approvals << current_user.id
              @scholarship.save
              redirect_back(fallback_location: scholarship_path(@scholarship))
              flash[:notice] = "You have successfully voted to approve this application."
            elsif @scholarship.approvals.count >= 1
              @scholarship.approvals << current_user.id
              @scholarship.update_attributes(final_decision: "Approved")
              @scholarship.save
              redirect_back(fallback_location: scholarship_path(@scholarship))
              flash[:notice] = "That application has been officially approved!"
            else
              redirect_back(fallback_location: scholarship_path(@scholarship))
              flash[:warning] = "Something went wrong.  Please try your request again later."
            end
          end
        end
      end
    end

    def reject_scholarship
      @scholarship = Scholarship.find(params[:id])
      if current_user && @scholarship.user.id == current_user.id
        redirect_back(fallback_location: scholarship_path(@scholarship))
        flash[:warning] = "Sorry, you cannot vote on your own application!"
      else
        if @scholarship.status == "Submitted to Committee" && ( @scholarship.final_decision == "Not Decided" || @scholarship.final_decision == "Modifications Requested" )
          if @scholarship.rejections.include?(current_user.id.to_s) || @scholarship.approvals.include?(current_user.id.to_s)
            redirect_back(fallback_location: scholarship_path(@scholarship))
            flash[:warning] = "Sorry, you have already voted on that application!"
          else
            if @scholarship.rejections.count < 1
              @scholarship.rejections << current_user.id
              @scholarship.save
              redirect_back(fallback_location: scholarship_path(@scholarship))
              flash[:notice] = "You have successfully voted to reject this application."
            elsif @scholarship.rejections.count >= 1
              @scholarship.rejections << current_user.id
              @scholarship.update_attributes(final_decision: "Approved")
              @scholarship.save
              redirect_back(fallback_location: scholarship_path(@scholarship))
              flash[:notice] = "That application has been officially rejected!"
            else
              redirect_back(fallback_location: scholarship_path(@scholarship))
              flash[:warning] = "Something went wrong.  Please try your request again later."
            end
          end
        end
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
        flash[:warning] = "Sorry, you cannot view that application at this time.  If you believe you have gotten this message in error, please contact the system administrator at admin@tocacares.com."
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scholarship
      @scholarship = Scholarship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scholarship_params
      params.require(:scholarship).permit(:application_type, :full_name, :date, :position, :branch, :start_date, :email_non_toca, :mobile, :address, :city, :state, :zip, :institution_name, :institution_contact, :institution_phone, :institution_address, :requested_amount, :self_fund, :scholarship_description, :intent_signature, :intent_signature_date, :release_signature, :release_signature_date, :status, :final_decision, :returned, :approvals, :rejections, :user_id)
    end
end
