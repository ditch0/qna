class Question < ApplicationRecord
  include Attachmentable
  include Votable
  include Commentable

  validates :title, presence: true
  validates :body,  presence: true

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_and_belongs_to_many :followers, class_name: 'User', join_table: :questions_subscriptions

  after_create :add_user_to_followers

  def user_can_vote?(user)
    user_id != user.id
  end

  private

  def add_user_to_followers
    followers << user
  end
end
