class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :user
  belongs_to :question

  before_save :unset_previous_best_answer, if: :is_best

  scope :best_and_newest_order, -> { order(is_best: :desc, id: :desc) }

  private

  def unset_previous_best_answer
    question.answers.where(is_best: true).find_each do |answer|
      answer.update_attributes(is_best: false)
    end
  end
end
