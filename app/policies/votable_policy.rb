module VotablePolicy
  extend ActiveSupport::Concern

  def vote_up?
    can_vote?
  end

  def vote_down?
    can_vote?
  end

  def reset_vote?
    can_vote?
  end

  protected

  def can_vote?
    authorized? && !owner?
  end
end
