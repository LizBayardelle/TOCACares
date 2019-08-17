class VotesController < ApplicationController
  before_action :set_vote, only: [:destroy, :own_vote_only]
  before_action :authenticate_user!
  before_action :set_application, only: [:create, :second_vote]
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
      format.html { redirect_to votes_url, notice: 'You have successfully deleted your vote and can now cast another one on this application.' }
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

      @other_votes = Vote.where(app_type: @vote.app_type, app_id: @vote.app_id).where.not(id: @vote.id)
      @other_votes.update_all(superseded: true)

      # Send email to user about requested vote

      if @vote.app_type == "hardship"
        @application = Hardship.find_by(id: @vote.app_id)
      elsif @vote.app_type == "scholarship"
        @application = Scholarship.find_by(id: @vote.app_id)
      elsif @vote.app_type == "charity"
        @application = Charity.find_by(id: @vote.app_id)
      end

      @application.update_attributes(status: "Returned for Votes", final_decision: "Votes Requested", approvals: [], rejections: [])

      if @vote.app_type == "hardship" && @application.for_other
        #send applicant email to transfer ownership
        #send email to submitting member
      else
        #send vote email to applicant
      end

      redirect_to home_pending_path
      flash[:notice] = "That vote has been successfully seconded. Thank you for serving on the deciding committee!"
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
