class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update, :set_best_answer]
  before_action :ensure_current_user_is_question_owner, only: [:destroy, :update, :set_best_answer]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.question = @question
    @answers = sorted_answers
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to questions_url
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    if @question.destroyed?
      redirect_to questions_url, notice: 'Question is deleted.'
    else
      redirect_to @question, alert: 'Cannot delete question.'
    end
  end

  def update
    @question.update(question_params)
  end

  def set_best_answer
    @question.best_answer = Answer.find(params[:answer_id])
    @question.save
    @answers = sorted_answers
  end

  private

  def sorted_answers
    @question.answers.sort_by do |answer|
      [
        answer == @question.best_answer ? 0 : 1,
        -1 * answer.id
      ]
    end
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def ensure_current_user_is_question_owner
    return if @question.user_id == current_user.id
    respond_to do |format|
      format.html { redirect_to @question, alert: 'Not allowed.' }
      format.js { head :forbidden }
    end
  end
end
