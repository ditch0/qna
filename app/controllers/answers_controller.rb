class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy, :update, :set_is_best]
  before_action :ensure_current_user_is_answer_owner, only: [:destroy, :update]
  before_action :ensure_current_user_is_question_owner, only: [:set_is_best]

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
    @answer.is_best = params[:is_best]
    @answer.save
    @answers = @answer.question.answers.best_and_newest_order
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
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
