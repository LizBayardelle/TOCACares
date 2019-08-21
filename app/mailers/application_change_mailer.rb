class ApplicationChangeMailer < ApplicationMailer
  default :from => "admin@tocacares.com"

  def new_application_email(application)
    @application = application
        mail(
          bcc: User.committee_users.pluck(:email),
          subject: 'New Application for Consideration on TOCA Cares'
        )
  end

  def funding_completed_email(application)
    @application = application
        mail(
          to: application.email_non_toca,
          subject: 'Funding for Your TOCA Cares Application is Complete'
        )
  end
end
