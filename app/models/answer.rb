class Answer < ApplicationRecord
  include Attachmentable
  include Votable
  include Commentable

  validates :body, presence: true
  belongs_to :user
  belongs_to :question

  scope :best_and_newest_order, -> { order(is_best: :desc, id: :desc) }

  after_commit :send_emails_to_question_followers, on: :create

  def update_is_best(is_best)
    ActiveRecord::Base.transaction do
      question.answers.update_all(is_best: false)
      update(is_best: is_best)
    end
  end

  def user_can_vote?(user)
    user_id != user.id
  end

  private

  def send_emails_to_question_followers
    question.followers.find_each do |user|
      QuestionsMailer.new_answer(user, self).deliver_later
    end
  end
end
