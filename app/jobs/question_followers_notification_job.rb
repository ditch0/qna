class QuestionFollowersNotificationJob < ApplicationJob
  queue_as :default

  def perform(new_answer)
    new_answer.question.followers.find_each do |user|
      QuestionsMailer.new_answer(user, new_answer).deliver_later
    end
  end
end
