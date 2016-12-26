class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def user_abilities
    guest_abilities
    can :create,  [Question, Answer, Comment]
    can :update,  [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can [:vote_up, :vote_down, :reset_vote], [Question, Answer] do |votable|
      votable.user_id != user.id
    end
    can :set_is_best, Answer do |answer|
      answer.question.user_id == user.id
    end
  end

  def guest_abilities
    can :read, :all
  end
end
