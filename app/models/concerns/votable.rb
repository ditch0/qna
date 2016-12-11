module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  def rating
    votes.sum(:value)
  end

  def reset_vote(user)
    votes.where(user_id: user.id).destroy_all
  end

  def find_vote_by_user(user)
    votes.find_by(user_id: user.id)
  end

  def user_can_vote?(_user)
    raise Exception, 'Votable#user_can_vote? must be overriden'
  end

  private

  def vote(user, value)
    ensure_user_can_vote!(user)
    vote = votes.find_or_initialize_by(user_id: user.id)
    vote.value = value
    vote.save
  end

  def ensure_user_can_vote!(user)
    return if user_can_vote?(user)
    raise Exception, "User #{user.id} is forbidden to vote for #{self.class.name} with id #{id}"
  end
end
