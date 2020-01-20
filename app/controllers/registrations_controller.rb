class RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_captcha, only: :create
  invisible_captcha only: [:create], honeypot: :subtitle
  after_action :update_authorizations, only: [:create]

  def create
    super
    Log.create(category: "User Action", action: "New User Account Created", automatic: false, object: true, object_linkable: true, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: @user.id)
    if AccountActionsMailer.new_user_needs_authorization_email(@user).deliver
      Log.create(category: "Email", action: "New User Needs Authorization Email Sent", automatic: true, object: true, object_linkable: true, object_category: "User", object_id: @user.id, taken_by_user: false)
    end
    if @user.persisted?
    end
  end


  def update
    super
    Log.create(category: "User Action", action: "User Updated Account Information", automatic: false, object: true, object_linkable: false, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: @user.id)
    # redirect_to user_path(resource)
  end


  protected

  def after_update_path_for(resource)
    user_path(resource)
  end

  # def after_sign_up_path_for(resource)
  #   static_path(:ThankYou)
  # end

  def update_authorizations
    authorizations = Authorization.all
    authorizations.each do |a|
      if @user.email == a.email
        a.account_created = true
        a.save
        @user.admin = a.admin
        @user.committee = a.committee
        @user.save
        Log.create(category: "Automatic", action: "New User Authorizations Automatically Applied", automatic: true, object: true, object_linkable: false, object_category: "user", object_id: @user.id, taken_by_user: false)
      end
    end


    hardships = Hardship.where(transfer_pending: true)
    hardships.each do |h|
      if @user.email == h.recipient_toca_email

        # transfer application
        h.user_id = @user.id
        h.transfer_pending = false
        if h.save
          Log.create(category: "Automatic", action: "Hardship Applicaton Transferred from Submitting User to Beneficiary", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: h.id, taken_by_user: false)
        end

        # Hardship transfer email to beneficiary
        if HardshipMailer.hardship_transferred_email(h).deliver
          Log.create(category: "Email", action: "Hardship Transfer Email Sent", automatic: true, object: true, object_linkable: true, object_category: h.application_type, object_id: h.id, taken_by_user: false)
        end


        # IF ACCEPTED
        if h.accepted
            # notification email to beneficiary
            if HardshipMailer.by_other_hardship_accepted_email(h).deliver
              Log.create(category: "Automatic", action: "Hardship Application Accepted Email sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: h.id, taken_by_user: false)
            end

            # hardship accepted email to helping hands
            if HardshipMailer.approved_hardship_to_helping_hands_email(h).deliver
              Log.create(category: "Email", action: "Accepted Hardship Application Sent to Helping Hands", automatic: true, object: true, object_linkable: true, object_category: h.application_type, object_id: h.id, taken_by_user: false)
            end

            # hardship accepted email to beneficiary
            if HardshipMailer.by_other_hardship_accepted_email(h).deliver
              Log.create(category: "Automatic", action: "Hardship Application Accepted Email sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: h.id, taken_by_user: false)
            end
        end # IF ACCEPTED


        # IF MODIFIED
        if h.returned

            # hardship modified email to beneficiary
            if HardshipMailer.by_other_hardship_modified_email(h).deliver
              Log.create(category: "Automatic", action: "Hardship Application Request for Modifications Email sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: h.id, taken_by_user: false)
            end

            # notification to submitter (not beneficiary)
            if AccountActionsMailer.for_other_hardship_modified_email(h).deliver
              Log.create(category: "Email", action: "For Other Hardship Application Modified Email Sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: h.application_type, object_id: h.id, taken_by_user: false)
            end

        end # IF MODIFIED


      end # IF USER EMAIL = RECIPIENT EMAIL
    end # HARDSHIPS EACH
  end # UPDATE AUTHORIZATIONS METHOD


  def sign_up_params
    params.require(:user).permit(
      :authorized_by_admin,
      :first_name,
      :last_name,
      :email,
      :phone,
      :location,
      :password,
      :password_confirmation,
      :admin,
      :committee,
      :committee_request
    )
  end

  def account_update_params
    params.require(:user).permit(
      :authorized_by_admin,
      :first_name,
      :last_name,
      :email,
      :phone,
      :location,
      :password,
      :password_confirmation,
      :current_password,
      :admin,
      :committee,
      :committee_request
    )
  end
end
