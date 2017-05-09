class QuestionPolicy < ApplicationPolicy
  include VotablePolicy

  def follow?
    authorized? && !follows?
  end

  def unsubscribe?
    authorized? && follows?
  end

  protected

  def follows?
    @record.follower_ids.include?(@user.id)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
