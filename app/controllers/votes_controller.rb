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
        end # vote save
      end # respond to format
    end # if vote not duplicate
  end #end method



  def update
    if @vote.update(vote_params)
      redirect_back(fallback_location: home_applications_path)
      flash[:notice] = "Your vote has been successfully changed."
    else
      redirect_back(fallback_location: home_applications_path)
      flash[:alert] = "Uh oh!  Something went wrong.  Please try again later."
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

      ## ACCEPTED APPLICATIONS
      if @vote.accept
        @application.update_attributes(status: "Decision Reached", final_decision: "Approved", approved: true)
        Log.create(category: "Committee Action", action: "An Application Was Approved", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: false)

        # FOR OTHER HARDSHIPS
        if @application.application_type == "hardship" && @application.for_other

          # if recipient has TOCA Cares account
          if User.where(email: @application.recipient_toca_email).count != 0

              # Transfer application authorization
              @application.user_id = User.where(email: @application.recipient_toca_email).first.id
              if @application.save
                Log.create(category: "Automatic", action: "Hardship Application Transferred from Submitter to Beneficiary", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end

              # Hardship transfer email to beneficiary
              if HardshipMailer.hardship_transferred_email(@application).deliver
                Log.create(category: "Email", action: "Hardship Transfer Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end

              # hardship accepted email to helping hands
              if HardshipMailer.approved_hardship_to_helping_hands_email(@application).deliver
                Log.create(category: "Email", action: "Accepted Hardship Application Sent to Helping Hands", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end

              # hardship accepted email to beneficiary
              if HardshipMailer.by_other_hardship_accepted_email(@application).deliver
                Log.create(category: "Automatic", action: "Hardship Application Accepted Email sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: @application.id, taken_by_user: false)
              end

          # recipient doesn't have TOCA Cares account
          else

              # transfer authorization created
              if @application.update_attributes(transfer_pending: true)
                Log.create(category: "Automatic", action: "Preemptive Transfer Authorization Created for Approved Hardship Application Created by Other", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end

              # create a new account email
              if AccountActionsMailer.create_an_account_email(@application).deliver
                Log.create(category: "Email", action: "Create an Account Invitation Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end

              ###NOTE: email notifications to beneficiary, submitter, & helping hands called once user creates account, in RegistrationsController
          end

          # hardship accepted email to SUBMITTING member
          if HardshipMailer.for_other_hardship_accepted_email(@application).deliver
            Log.create(category: "Email", action: "For Other Hardship Application Accepted Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
          end


        # ALL SELF-SUBMITTED APPLICATIONS
        else
          if @vote.application_type == "hardship"
            if HardshipMailer.hardship_accepted_email(@application).deliver
              Log.create(category: "Email", action: "Hardship Application Accepted Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
            if HardshipMailer.approved_hardship_to_helping_hands_email(@application).deliver
              Log.create(category: "Email", action: "Accepted Hardship Application Sent to Helping Hands", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          elsif @vote.application_type == "scholarship"
            if ScholarshipMailer.scholarship_accepted_email(@application).deliver
              Log.create(category: "Email", action: "Scholarship Application Accepted Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
            if ScholarshipMailer.approved_scholarship_to_helping_hands_email(@application).deliver
              Log.create(category: "Email", action: "Accepted Scholarship Application Sent to Helping Hands", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          elsif @vote.application_type == "charity"
            if CharityMailer.charity_accepted_email(@application).deliver
              Log.create(category: "Email", action: "Charity Application Accepted Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
            if CharityMailer.approved_charity_to_helping_hands_email(@application).deliver
              Log.create(category: "Email", action: "Accepted Charity Application Sent to Helping Hands", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          end
        end

      ## MODIFIED APPLICATIONS
      elsif @vote.modify
        @application.update_attributes(status: "Returned for Modifications", final_decision: "Modifications Requested", returned: true)
        Log.create(category: "Committee Action", action: "An Application Was Returned for Modifications", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: false)

        # FOR OTHER HARDSHIPS
        if @application.application_type == "hardship" && @application.for_other

          # if user has a TOCA Cares account already
          if User.where(email: @application.recipient_toca_email).count != 0

              # application transfer
              @application.user_id = User.where(email: @application.recipient_toca_email).first.id
              if @application.save
                Log.create(category: "Automatic", action: "Hardship Application Transferred from Submitter to Beneficiary", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end

              # hardship transferred email to submitting member
              if HardshipMailer.hardship_transferred_email(@application).deliver
                Log.create(category: "Email", action: "Hardship Transferred Email Sent to Submitter", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end

              # notification to submitter (not beneficiary)
              if AccountActionsMailer.for_other_hardship_modified_email(@application).deliver
                Log.create(category: "Email", action: "For Other Hardship Application Modified Email Sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end


          # if user has to make a TOCA Cares Account
          else
              #transfer authorization created
              if @application.update_attributes(transfer_pending: true)
                Log.create(category: "Automatic", action: "Preemptive Transfer Authorization Created for Modifications Requested Hardship Application Created by Other", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end
              # create an account email sent to beneficiary
              if AccountActionsMailer.create_an_account_email(@application).deliver
                Log.create(category: "Email", action: "Create an Account Invitation Email Sent to Hardship Beneficiary", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
              end
          end


        # ALL SELF-SUBMITTED APPLICATIONS
        else
          if @vote.application_type == "hardship"
            if HardshipMailer.hardship_modification_request_email(@application).deliver
              Log.create(category: "Email", action: "Hardship Application Needs Modifications Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          elsif @vote.application_type == "scholarship"
            if ScholarshipMailer.scholarship_modification_request_email(@application).deliver
              Log.create(category: "Email", action: "Scholarship Application Needs Modifications Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          elsif @vote.application_type == "charity"
            if CharityMailer.charity_modification_request_email(@application).deliver
              Log.create(category: "Email", action: "Charity Application Needs Modifications Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          end
        end

      ## DENIED APPLICATIONS
      elsif @vote.deny
        if @application.update_attributes(status: "Decision Reached", final_decision: "Rejected", denied: true)
          Log.create(category: "Committee Action", action: "An Application Was Denied", automatic: false, object: true, object_linkable: true, object_category: @vote.application_type, object_id: @vote.application_id, taken_by_user: false)
        end

        # if for other person
        if @application.application_type == "hardship" && @application.for_other

          #send rejection email to submitting member
          if AccountActionsMailer.for_other_hardship_denied_email(@application).deliver
            Log.create(category: "Email", action: "Hardship Application (Submitted for Other) Denied Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
          end

        else # not for others

          if @vote.application_type == "hardship"
            if HardshipMailer.hardship_denied_email(@application).deliver
              Log.create(category: "Email", action: "Hardship Application Denied Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          elsif @vote.application_type == "scholarship"
            if ScholarshipMailer.scholarship_denied_email(@application).deliver
              Log.create(category: "Email", action: "Scholarship Application Denied Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          elsif @vote.application_type == "charity"
            if CharityMailer.charity_denied_email(@application).deliver
              Log.create(category: "Email", action: "Charity Application Denied Email Sent", automatic: true, object: true, object_linkable: true, object_category: @application.application_type, object_id: @application.id, taken_by_user: false)
            end
          end

        end # application for self or others if/else
      end #end vote statuses (accept/modify/deny)

      redirect_to home_applications_path
      flash[:notice] = "That vote has been successfully seconded and the application is being processed accordingly. Thank you for serving on the deciding committee!" # if current user isn't vote owner or applicatnt
    end # End if current user isn't vote owner or applicatnt
  end # Second vote method



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

      :superseded,
      :seconded
    )
  end
end
