class Question < ApplicationRecord
  validates :title, presence: true
  validates :body,  presence: true
  validate :best_answer_belongs_to_this_question
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, optional: true, class_name: 'Answer'
  belongs_to :user

  private

  def best_answer_belongs_to_this_question
    return if best_answer.nil? || best_answer.question_id == id
    errors.add(:best_answer, 'must belong to this question')
  end
end
