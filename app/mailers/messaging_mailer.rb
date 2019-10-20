class MessagingMailer < ApplicationMailer

  default :from => "admin@tocacares.com"

  def new_message_email(message)
    @message = message
    if User.find(@message.from_user_id).admin || User.find(@message.from_user_id).committee
      mail(
        to: @message.user.email,
        subject: 'New Message for you on TOCA Cares'
      )
    else
      mail(
        bcc: User.admin_and_committee_users.pluck(:email),
        subject: "There's a New Message Regarding a TOCA Cares Application"
      )
    end
  end

  def new_response_email(response)
    @response = response
    @message = Message.find(@response.message_id)
    @application = eval("#{@message.ref_application_type.capitalize}").find(@message.ref_application_id)

    if @response.user_id == @application.user.id
      mail(
        bcc: User.admin_and_committee_users.pluck(:email),
        subject: "There's a New Message Response Regarding a TOCA Cares Application"
      )
    else
      mail(
        to: @message.user.email,
        subject: 'New Message Response about Your TOCA Cares Application'
      )
    end  end

end
