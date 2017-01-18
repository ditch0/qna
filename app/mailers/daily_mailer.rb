class DailyMailer < ApplicationMailer
  default from: 'from@example.com'

  def digest(user, new_questions)
    @questions = new_questions
    mail to: user.email, subject: 'New questions'
  end
end
