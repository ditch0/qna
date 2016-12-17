class QuestionsController < ApplicationController
  include CanVote

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update, :set_best_answer]
  before_action :add_question_id_to_gon, only: [:show]
  before_action :ensure_current_user_is_question_owner, only: [:destroy, :update, :set_best_answer]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.best_and_newest_order
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

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def add_question_id_to_gon
    gon.question_id = @question.id
  end

  def publish_question
    return unless @question.persisted?
    question_html = ApplicationController.render(
      partial: 'questions/question',
      locals: { question: @question }
    )
    ActionCable.server.broadcast 'questions', question_html
  end

  def ensure_current_user_is_question_owner
    return if @question.user_id == current_user.id
    respond_to do |format|
      format.html { redirect_to @question, alert: 'Not allowed.' }
      format.js { head :forbidden }
    end
  end
end
