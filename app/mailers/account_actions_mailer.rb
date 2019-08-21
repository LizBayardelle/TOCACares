class AccountActionsMailer < ApplicationMailer

  def create_an_account_email(email)
    @email = email
    mail(
      to: @email,
      subject: 'Please Create an Account on TOCACares.com'
    )
  end

end
