class HardshipMailer < ApplicationMailer
  default :from => "support@tocacares.com"

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

  def hardship_modification_request_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'Modifications Have Been Requested for Your TOCA Cares Hardship Application'
    )
  end



#HELPING HANDS
  def approved_hardship_to_helping_hands_email(application)
    @application = application
    mail(
      to: "missy@hhmin.org",
      subject: 'New TOCA Cares Hardship Funding'
    )
  end



# BY OTHER NOTIFICATIONS
  def hardship_transferred_email(application)
    @application = application
    mail(
      to: @application.recipient_toca_email,
      subject: 'Ownership of a Hardship Application has Been Transferred to your TOCA Cares Account'
    )
  end

  def by_other_hardship_accepted_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'A TOCA Cares Hardship Application Submitted on Your Behalf Has Been Accepted'
    )
  end

  def by_other_hardship_modified_email(application)
    @application = application
    mail(
      to: @application.email_non_toca,
      subject: 'A TOCA Cares Hardship Application Submitted on Your Behalf Needs Modifications'
    )
  end



#FOR OTHER NOTIFICATIONS
  def for_other_hardship_accepted_email(application)
    @application = application
    mail(
      to: @application.for_other_email,
      subject: 'The TOCA Cares Hardship Application You Submitted for a Coworker Has Been Accepted'
    )
  end

  def for_other_hardship_modified_email(application)
    @application = application
    mail(
      to: @application.for_other_email,
      subject: 'The TOCA Cares Hardship Application You Submitted for a Coworker Has Been Modified'
    )
  end

  def for_other_hardship_denied_email(application)
    @application = application
    mail(
      to: @application.for_other_email,
      subject: 'The TOCA Cares Hardship Application You Submitted for a Coworker Has Been Denied'
    )
  end

end
