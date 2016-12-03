class Question < ApplicationRecord
  validates :title, presence: true
  validates :body,  presence: true

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments, allow_destroy: true
end
