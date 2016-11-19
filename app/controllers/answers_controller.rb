class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy]
  before_action :ensure_current_user_is_answer_owner, only: [:destroy]

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
    if @answer.destroyed?
      redirect_to @answer.question, notice: 'Answer is deleted.'
    else
      redirect_to @answer.question, alert: 'Cannot delete answer.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def ensure_current_user_is_answer_owner
    unless @answer.user_id == current_user.id
      redirect_to @answer.question, alert: 'Not allowed.'
    end
  end
end
