class TestimonialMailer < ApplicationMailer
  default :from => "admin@tocacares.com"

  def send_testimonial_email(testimonial)
    @testimonial = testimonial
    mail(
      bcc: User.admin_users.pluck(:email),
      subject: 'New Testimonial for Approval on TOCA Cares'
    )
  end

end
