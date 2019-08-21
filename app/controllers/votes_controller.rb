class VotesController < ApplicationController
  before_action :set_vote, only: [:destroy, :own_vote_only]
  before_action :authenticate_user!
  before_action :set_application, only: [:second_vote]
  before_action :own_vote_only, only: [:destroy]
  before_action :committee_only, only: [:new, :create, :destroy]



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

    respond_to do |format|
      if @vote.save
        format.html { redirect_to home_applications_path, notice: 'Your vote was successfully cast.  If seconded by another committee member, the application status will be updated.' }
        format.json { render :show, status: :created, location: @vote }
      else
        format.html { render :new }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end



  def destroy
    @vote.destroy
    respond_to do |format|
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
        if @application.application_type == "hardship" && @application.for_other
          if User.where(email: @application.recipient_toca_email).count != 0
            @application.user_id = User.where(email: @application.recipient_toca_email).first.id
            @application.save
            HardshipMailer.hardship_transferred_email(@application).deliver
          else
            AccountActionsMailer.create_an_account_email(@application.recipient_toca_email).deliver
          end
          HardshipMailer.for_other_hardship_accepted_email(@application).deliver
        else
          if @vote.application_type == "hardship"
            HardshipMailer.hardship_accepted_email(@application).deliver
          elsif @vote.application_type == "scholarship"
            ScholarshipMailer.scholarship_accepted_email(@application).deliver
          elsif @vote.application_type == "charity"
            CharityMailer.charity_accepted_email(@application).deliver
          end
        end
      elsif @vote.modify
        @application.update_attributes(status: "Returned for Modifications", final_decision: "Modifications Requested", returned: true)
        if @application.application_type == "hardship" && @application.for_other
          if User.where(email: @application.recipient_toca_email).count != 0
            @application.user_id = User.where(email: @application.recipient_toca_email).first.id
            @application.save
            HardshipMailer.hardship_transferred_email(@application).deliver
          else
            AccountActionsMailer.create_an_account_email(@application.recipient_toca_email).deliver
          end
          # send for other modified and transferred emaile
        else
          if @vote.application_type == "hardship"
            #send modification email to applicant
          elsif @vote.application_type == "scholarship"
            #send modification email to applicant
          elsif @vote.application_type == "charity"
            #send modification email to applicant
          end
        end
      elsif @vote.deny
        @application.update_attributes(status: "Decision Reached", final_decision: "Rejected", denied: true)
        if @application.application_type == "hardship" && @application.for_other
          #send rejection email to submitting member
        else
          if @vote.application_type == "hardship"
            HardshipMailer.hardship_denied_email(@application).deliver
          elsif @vote.application_type == "scholarship"
            ScholarshipMailer.scholarship_denied_email(@application).deliver
          elsif @vote.application_type == "charity"
            CharityMailer.charity_denied_email(@application).deliver
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
