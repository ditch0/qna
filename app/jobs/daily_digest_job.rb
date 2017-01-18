class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    new_questions = Question.where(created_at: Date.yesterday.midnight..Date.yesterday.end_of_day).to_a
    return if new_questions.count.zero?
    User.find_each.each do |user|
      DailyMailer.digest(user, new_questions).deliver_later
    end
  end
end
