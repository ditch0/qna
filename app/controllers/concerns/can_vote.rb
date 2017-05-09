module CanVote
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:vote_up, :vote_down, :reset_vote]
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
    authorize @votable
  end

  def model_klass
    controller_name.classify.constantize
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
