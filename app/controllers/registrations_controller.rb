class RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_captcha, only: :create
  invisible_captcha only: [:create], honeypot: :subtitle
  after_action :update_authorizations, only: [:create]

  def create
    super
    Log.create(category: "User Action", action: "New User Account Created", automatic: false, object: true, object_linkable: false, object_category: "user", object_id: @user.id, taken_by_user: true, user_id: @user.id)
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
        h.user_id = @user.id
        h.transfer_pending = false
        h.save
        Log.create(category: "Automatic", action: "Hardship Applicaton Transferred from Submitting User to Beneficiary", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: h.id, taken_by_user: false)
        HardshipMailer.hardship_transferred_email(h).deliver
        Log.create(category: "Automatic", action: "Hardship Application Transfer Email sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: h.id, taken_by_user: false)
        if h.accepted
          HardshipMailer.by_other_hardship_accepted_email(h).deliver
          Log.create(category: "Automatic", action: "Hardship Application Accepted Email sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: h.id, taken_by_user: false)
        end
        if h.returned
          # send by other modification email
          Log.create(category: "Automatic", action: "Hardship Application Request for Modifications Email sent to Submitting User", automatic: true, object: true, object_linkable: true, object_category: "hardship", object_id: h.id, taken_by_user: false)
        end
      end
    end
  end


  def sign_up_params
    params.require(:user).permit(
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
