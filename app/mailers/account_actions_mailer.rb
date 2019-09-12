class AccountActionsMailer < ApplicationMailer

  def create_an_account_email(email)
    @email = email
    mail(
      to: @email,
      subject: 'Please Create an Account on TOCACares.com'
    )
  end

  def new_user_needs_authorization_email(user)
    @user = user
    mail(
      bcc: User.admin_users.pluck(:email),
      subject: 'A New TOCA Cares Account Needs Admin Authorization'
    )
  end

end
