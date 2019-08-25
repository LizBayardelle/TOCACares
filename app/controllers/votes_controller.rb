class VotesController < ApplicationController
  before_action :set_vote, only: [:update, :destroy, :own_vote_only]
  before_action :authenticate_user!
  before_action :set_application, only: [:second_vote]
  before_action :own_vote_only, only: [:update, :destroy]
  before_action :committee_only, only: [:new, :create, :update, :destroy]



  def set_application
    @vote = Vote.find(params[:id])
    if @vote.application_type == "hardship"
      @application = Hardship.find_by(id: @vote.application_id)
    elsif @vote.application_type == "scholarship"
      @application = Scholarship.find_by(id: @vote.application_id)
    elsif @vote.application_type == "charity"
      @application = Charity.find_by(id: @vote.application_id)
    end
  end



  def create
    @vote = Vote.new(vote_params)
    @vote.user_id = current_user.id

    if Vote.where(user_id: current_user.id, application_type: @vote.application_type, application_id: @vote.application_id).count != 0
      redirect_back(fallback_location: home_applications_path)
      flash[:warning] = "Sorry, you can only vote once per application.  If you changed your mind, you can change your existing vote as long as it hasn't been seconded yet."
    else
      respond_to do |format|
        if @vote.save
          Log.create(category: "Committee Action", action: "Committee Member Voted on an Application", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: true, user_id: current_user.id)
          format.html { redirect_to home_applications_path, notice: 'Your vote was successfully cast.  If seconded by another committee member, the application status will be updated.' }
          format.json { render :show, status: :created, location: @vote }
        else
          format.html { render :new }
          format.json { render json: @vote.errors, status: :unprocessable_entity }
        end
      end
    end
  end



  def update
      if @vote.update(vote_params)
        redirect_back(fallback_location: home_applications_path)
        flash[:notice] = "Your vote has been successfully changed."
      else
        redirect_back(fallback_location: home_applications_path)
        flash[:warning] = "Uh oh!  Something went wrong.  Please try again later."
    end
  end



  def destroy
    @vote.destroy
    respond_to do |format|
      Log.create(category: "Committee Action", action: "Committee Member Deleted Their Vote on an Application", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: true, user_id: current_user.id)
      format.html { redirect_to home_applications_url, notice: 'You have successfully deleted your vote and can now cast another one on this application.' }
      format.json { head :no_content }
    end
  end



  def own_vote_only
    unless current_user && ( @vote.user_id == current_user.id )
      redirect_back(fallback_location: home_applications_path)
      flash[:warning] = "Sorry, you can only perform that action with your own votes."
    end
  end



  def committee_only
    unless current_user && current_user.committee
      redirect_back(fallback_location: root_path)
      flash[:warning] = "Sorry, you must be a committee member to modify an application."
    end
  end



  def second_vote
    @vote = Vote.find(params[:id])

    if current_user && @vote.user.id == current_user.id
      redirect_back(fallback_location: home_pending_path)
      flash[:warning] = "Sorry, you cannot second a vote you submitted!"
    elsif current_user.id == @application.user.id
      redirect_back(fallback_location: home_pending_path)
      flash[:warning] = "Sorry, you cannot second a vote on your own application."
    else
      ## UPDATE VOTE STATUSES
      @other_votes = Vote.where(application_type: @vote.application_type, application_id: @vote.application_id).where.not(id: @vote.id)
      @other_votes.update_all(superseded: true)
      @vote.update_attributes(seconded: true)
      Log.create(category: "Committee Action", action: "A Vote Was Seconded", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: true, user_id: current_user.id)

      ## SET APPLICATION
      if @vote.application_type == "hardship"
        @application = Hardship.find_by(id: @vote.application_id)
      elsif @vote.application_type == "scholarship"
        @application = Scholarship.find_by(id: @vote.application_id)
      elsif @vote.application_type == "charity"
        @application = Charity.find_by(id: @vote.application_id)
      end

      ## UPDATE APPLICATION STATUSES
      if @vote.accept
        @application.update_attributes(status: "Decision Reached", final_decision: "Approved", approved: true)
        Log.create(category: "Committee Action", action: "An Application Was Approved", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: false)
        if @application.application_type == "hardship" && @application.for_other
          if User.where(email: @application.recipient_toca_email).count != 0
            @application.user_id = User.where(email: @application.recipient_toca_email).first.id
            @application.save
            HardshipMailer.hardship_transferred_email(@application).deliver
            Log.create(category: "Email", action: "Hardship Transfer Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          else
            AccountActionsMailer.create_an_account_email(@application.recipient_toca_email).deliver
            Log.create(category: "Email", action: "Create an Account Invitation Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          end
          HardshipMailer.for_other_hardship_accepted_email(@application).deliver
          Log.create(category: "Email", action: "For Other Hardship Application Accepted Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
        else
          if @vote.application_type == "hardship"
            HardshipMailer.hardship_accepted_email(@application).deliver
            Log.create(category: "Email", action: "Hardship Application Accepted Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          elsif @vote.application_type == "scholarship"
            ScholarshipMailer.scholarship_accepted_email(@application).deliver
            Log.create(category: "Email", action: "Scholarship Application Accepted Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          elsif @vote.application_type == "charity"
            CharityMailer.charity_accepted_email(@application).deliver
            Log.create(category: "Email", action: "Charity Application Accepted Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          end
        end
      elsif @vote.modify
        @application.update_attributes(status: "Returned for Modifications", final_decision: "Modifications Requested", returned: true)
        Log.create(category: "Committee Action", action: "An Application Was Returned for Modifications", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: false)
        if @application.application_type == "hardship" && @application.for_other
          if User.where(email: @application.recipient_toca_email).count != 0
            @application.user_id = User.where(email: @application.recipient_toca_email).first.id
            @application.save
            Log.create(category: "Automatic", action: "Hardship Application Transferred from Submitter to Beneficiary", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
            HardshipMailer.hardship_transferred_email(@application).deliver
            Log.create(category: "Email", action: "Hardship Transferred Email Sent to Submitter", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          else
            AccountActionsMailer.create_an_account_email(@application.recipient_toca_email).deliver
            Log.create(category: "Email", action: "Create an Account Invitation Email Sent to Hardship Beneficiary", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          end
        else
          if @vote.application_type == "hardship"
            #send modification email to applicant
            Log.create(category: "Email", action: "Hardship Application Needs Modifications Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          elsif @vote.application_type == "scholarship"
            #send modification email to applicant
            Log.create(category: "Email", action: "Scholarship Application Needs Modifications Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          elsif @vote.application_type == "charity"
            #send modification email to applicant
            Log.create(category: "Email", action: "Charity Application Needs Modifications Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          end
        end
      elsif @vote.deny
        @application.update_attributes(status: "Decision Reached", final_decision: "Rejected", denied: true)
        Log.create(category: "Committee Action", action: "An Application Was Denied", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: false)
        if @application.application_type == "hardship" && @application.for_other
          #send rejection email to submitting member
          Log.create(category: "Email", action: "Hardship Application (Submitted for Other) Denied Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
        else
          if @vote.application_type == "hardship"
            HardshipMailer.hardship_denied_email(@application).deliver
            Log.create(category: "Email", action: "Hardship Application Denied Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          elsif @vote.application_type == "scholarship"
            ScholarshipMailer.scholarship_denied_email(@application).deliver
            Log.create(category: "Email", action: "Scholarship Application Denied Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          elsif @vote.application_type == "charity"
            CharityMailer.charity_denied_email(@application).deliver
            Log.create(category: "Email", action: "Charity Application Denied Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.application_id, taken_by_user: false)
          end
        end
      end

      redirect_to home_applications_path
      flash[:notice] = "That vote has been successfully seconded and the application is being processed accordingly. Thank you for serving on the deciding committee!"
    end
  end



  private

    def set_vote
      @vote = Vote.find(params[:id])
    end



    def vote_params
      params.require(:vote).permit(
        :application_type,
        :application_id,
        :user_id,

        :accept,

        :modify,
        :modification,
        :suggest_loan,
        :describe_loan,

        :deny,
        :denial_fund_overuse,
        :denial_not_qualify,
        :denial_unreasonable_request,
        :denial_not_involved_charity,
        :denial_other,
        :denial_other_description,

        :superseded
      )
    end
end
