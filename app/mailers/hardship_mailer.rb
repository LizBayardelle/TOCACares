class HardshipMailer < ApplicationMailer
  default :from => "admin@tocacares.com"

  def hardship_accepted_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Your TOCA Cares Hardship Application Has Been Accepted'
    )
  end

  def hardship_denied_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Your TOCA Cares Hardship Application Has Been Denied'
    )
  end

  def hardship_modification_request_email(application, modification)
    @application = application
    @modification = modification
    mail(
      to: @application.email_non_toca,
      subject: 'Modifications Have Been Requested for Your TOCA Cares Hardship Application'
    )
  end

  def by_other_hardship_accepted_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'A TOCA Cares Hardship Application Submitted on Your Behalf Has Been Accepted'
    )
  end

  def for_other_hardship_accepted
  end
end
