# Preview all emails at http://localhost:3000/rails/mailers/messaging_mailer
class MessagingMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/messaging_mailer/new_message_email
  def new_message_email
    MessagingMailer.new_message_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/messaging_mailer/new_response_email
  def new_response_email
    MessagingMailer.new_response_email
  end

end
