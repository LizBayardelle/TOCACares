# Preview all emails at http://localhost:3000/rails/mailers/account_creation_mailer
class AccountCreationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/account_creation_mailer/create_an_account_email
  def create_an_account_email
    AccountCreationMailer.create_an_account_email
  end

end
