class Question < ApplicationRecord
  include Attachmentable
  include Votable
  include Commentable

  validates :title, presence: true
  validates :body,  presence: true

  has_many :answers, dependent: :destroy
  belongs_to :user

  def user_can_vote?(user)
    user_id != user.id
  end
end
