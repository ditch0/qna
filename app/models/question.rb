class Question < ApplicationRecord
  include Attachmentable

  validates :title, presence: true
  validates :body,  presence: true

  has_many :answers, dependent: :destroy
  belongs_to :user
end
