class ScholarshipMailer < ApplicationMailer
  default :from => "admin@tocacares.com"

  def scholarship_accepted_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Your TOCA Cares Scholarship Application Has Been Accepted'
    )
  end

  def scholarship_denied_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Your TOCA Cares Scholarship Application Has Been Denied'
    )
  end

  def scholarship_modification_request_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Modifications Have Been Requested for Your TOCA Cares Scholarship Application'
    )
  end
end
