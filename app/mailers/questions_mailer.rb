class QuestionsMailer < ApplicationMailer
  default from: 'from@example.com'

  def new_answer(user, answer)
    @answer = answer
    mail to: user.email, subject: "New answer for #{answer.question.title}"
  end
end
