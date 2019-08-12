class NewApplicationMailer < ApplicationMailer
  default :from => "admin@tocacares.com"

  def send_new_application_email(application)
    @application = application
        mail(
          bcc: User.committee_users.pluck(:email),
          subject: 'New Application for Consideration on TOCA Cares'
        )
  end
end
