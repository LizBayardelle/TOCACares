class TestimonialMailer < ApplicationMailer
  default :from => "support@tocacares.com"

  def send_testimonial_email(testimonial)
    @testimonial = testimonial
    mail(
      bcc: User.admin_users.pluck(:email),
      subject: 'New Testimonial for Approval on TOCA Cares'
    )
  end

end
