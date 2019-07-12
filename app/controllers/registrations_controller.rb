class RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_captcha, only: :create
  invisible_captcha only: [:create], honeypot: :subtitle

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


  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :location, :password, :password_confirmation, :admin, :committee)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :location, :password, :password_confirmation, :current_password, :admin, :committee)
  end
end
