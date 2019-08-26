class NewQuestionMailer < ApplicationMailer
  def new_question_email(question)
    @question = question
    mail(
      bcc: User.admin_users.pluck(:email),
      subject: 'New Question Submitted on TOCA Cares'
    )
  end
end
