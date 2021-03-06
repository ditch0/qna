class QuestionsController < ApplicationController
  include CanVote

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_question, only: [:show, :destroy, :update, :set_best_answer, :follow, :unsubscribe]
  before_action :add_data_to_gon, only: [:show]
  after_action :publish_question, only: [:create]

  respond_to :html
  respond_to :js, only: :update

  def index
    authorize Question
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    authorize Question
    respond_with(@question = Question.new)
  end

  def create
    authorize Question
    @question = current_user.questions.create(question_params)
    respond_with @question, location: questions_url
  end

  def destroy
    respond_with @question.destroy
  end

  def update
    respond_with @question.update(question_params)
  end

  def follow
    @question.followers << current_user
    redirect_to @question
  end

  def unsubscribe
    @question.followers.destroy(current_user)
    redirect_to @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
    authorize @question
  end

  def add_data_to_gon
    gon.question = @question
    gon.user_id = current_user&.id
  end

  def publish_question
    return unless @question.persisted?
    question_html = ApplicationController.render(
      partial: 'questions/question',
      locals: { question: @question }
    )
    ActionCable.server.broadcast 'questions', question_html
  end
end
