class CharityMailer < ApplicationMailer
  default :from => "admin@tocacares.com"

  def charity_accepted_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Your TOCA Cares Charity Application Has Been Accepted'
    )
  end

  def approved_charity_to_helping_hands_email(application)
    @application = application
    mail(
      to: "lizbayardelle@gmail.com",
      # to: "missy@hhmin.org",
      subject: 'New TOCA Cares Charity Funding'
    )
  end

  def charity_denied_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Your TOCA Cares Charity Application Has Been Denied'
    )
  end

  def charity_modification_request_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Modifications Have Been Requested for Your TOCA Cares Charity Application'
    )
  end

end
