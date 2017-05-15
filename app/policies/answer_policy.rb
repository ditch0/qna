class AnswerPolicy < ApplicationPolicy
  include VotablePolicy

  def set_is_best?
    authorized? && @record.question.user_id == @user.id
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
