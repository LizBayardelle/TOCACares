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

  def hardship_transferred_email(application)
    @application = application
    mail(
      to: @application.recipient_toca_email,
      subject: 'Ownership of a Hardship Application has Been Transferred to your TOCA Cares Account'
    )

  def by_other_hardship_accepted_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'A TOCA Cares Hardship Application Submitted on Your Behalf Has Been Accepted'
    )
  end

  def for_other_hardship_accepted_email(application)
    @application = application
    mail(
      to: @application.for_other_email,
      subject: 'The TOCA Cares Hardship Application You Submitted for a Coworker Has Been Accepted'
    )
  end
end
