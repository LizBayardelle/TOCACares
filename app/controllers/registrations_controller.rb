class RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_captcha, only: :create
  invisible_captcha only: [:create], honeypot: :subtitle
  after_action :update_authorizations, only: [:create]

  def create
    super
    if @user.persisted?
    end
  end

  def update
    super
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
