class RegistrationsController < Devise::RegistrationsController
  # prepend_before_action :check_captcha, only: :create
  invisible_captcha only: [:create], honeypot: :subtitle

  def create
    super
    if @user.persisted?
    end
  end

  def update
  end


  protected

  # def after_update_path_for(resource)
  #   user_path(resource)
  # end
  #
  # def after_sign_up_path_for(resource)
  #   static_path(:ThankYou)
  # end


  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :admin, :subscribed, :avatar, :tagline, :bio, :website_name, :website_url, :sm_youtube, :sm_email, :sm_facebook, :sm_pinterest, :sm_instagram, :sm_twitter, :sm_other, :sm_youtube, :sm_email, :contributor, :contributor_request, :sm_approved, :sm_needs_approval, :source)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :admin, :subscribed, :avatar, :tagline, :bio, :website_name, :website_url, :sm_youtube, :sm_email, :sm_facebook, :sm_pinterest, :sm_instagram, :sm_twitter, :sm_other, :sm_youtube, :sm_email, :contributor, :contributor_request, :sm_approved, :sm_needs_approval, :source)
  end
end
