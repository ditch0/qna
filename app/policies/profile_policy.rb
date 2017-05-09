class ProfilePolicy
  attr_reader :user

  def initialize(user, profile = nil)
    @user = user
  end

  def me?
    authorized?
  end

  def index?
    authorized?
  end

  private

  def authorized?
    !@user.nil?
  end
end
