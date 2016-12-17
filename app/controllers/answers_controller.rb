class AnswersController < ApplicationController
  include CanVote

  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_answer, only: [:show, :destroy, :update, :set_is_best]
  before_action :ensure_current_user_is_answer_owner, only: [:destroy, :update]
  before_action :ensure_current_user_is_question_owner, only: [:set_is_best]
  after_action :publish_answer, only: :create

  def show
    render partial: 'answer', layout: false, locals: { answer: @answer }
  end

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy
  end

  def update
    @answer.update(answer_params)
  end

  def set_is_best
    @answer.update_is_best(params[:is_best])
    @answers = @answer.question.answers.best_and_newest_order
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    return unless @answer.persisted?
    ActionCable.server.broadcast "answers_#{@answer.question_id}", answer_id: @answer.id
  end

  def ensure_current_user_is_answer_owner
    return if @answer.user_id == current_user.id
    respond_with_forbidden
  end

  def ensure_current_user_is_question_owner
    return if @answer.question.user_id == current_user.id
    respond_with_forbidden
  end

  def respond_with_forbidden
    respond_to do |format|
      format.html { redirect_to @answer.question, alert: 'Not allowed.' }
      format.js { head :forbidden }
    end
  end
end
