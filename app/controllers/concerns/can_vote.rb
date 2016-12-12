module CanVote
  extend ActiveSupport::Concern

  included do
    voting_actions = [:vote_up, :vote_down, :reset_vote]
    before_action :set_voteable, only: voting_actions
    before_action :ensure_user_is_not_votable_owner, only: voting_actions
  end

  def vote_up
    @votable.vote_up(current_user)
    render_change_vote_response
  end

  def vote_down
    @votable.vote_down(current_user)
    render_change_vote_response
  end

  def reset_vote
    @votable.reset_vote(current_user)
    render_change_vote_response
  end

  private

  def set_voteable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def ensure_user_is_not_votable_owner
    return unless @votable.user_id == current_user.id
    respond_with_forbidden
  end

  def respond_with_forbidden
    respond_to do |format|
      format.html { redirect_to @question, alert: 'Not allowed.' }
      format.js { head :forbidden }
    end
  end

  def render_change_vote_response
    render json: {
      rating: @votable.rating,
      user_vote: @votable.find_vote_by_user(current_user)&.value
    }
  end
end
