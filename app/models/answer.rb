class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachmentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true

  scope :best_and_newest_order, -> { order(is_best: :desc, id: :desc) }

  def update_is_best(is_best)
    ActiveRecord::Base.transaction do
      question.answers.update_all(is_best: false)
      update(is_best: is_best)
    end
  end
end
