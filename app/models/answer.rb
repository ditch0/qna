class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :user
  belongs_to :question

  scope :best_and_newest_order, -> { order(is_best: :desc, id: :desc) }

  def update_is_best(is_best)
    ActiveRecord::Base.transaction do
      question.answers.update_all(is_best: false)
      self.is_best = is_best
      save
    end
  end
end
