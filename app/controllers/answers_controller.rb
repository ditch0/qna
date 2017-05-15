class AnswersController < ApplicationController
  include CanVote

  before_action :set_answer, only: [:destroy, :update, :set_is_best]
  after_action :publish_answer, only: :create

  respond_to :js

  def new
    authorize Answer
    respond_with(@answer = Answer.new)
  end

  def create
    authorize Answer
    @answer = current_user.answers.create(answer_params.merge(question_id: params[:question_id]))
    respond_with(@answer)
  end

  def destroy
    respond_with @answer.destroy
  end

  def update
    respond_with @answer.update(answer_params)
  end

  def set_is_best
    respond_with(
      @answer.update_is_best(params[:is_best]),
      @answers = @answer.question.answers.best_and_newest_order
    )
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def set_answer
    @answer = Answer.find(params[:id])
    authorize @answer
  end

  def publish_answer
    return unless @answer.persisted?
    ActionCable.server.broadcast "answers_#{@answer.question_id}", answer: @answer, attachments: @answer.attachments
  end

  def respond_with_forbidden
    respond_to do |format|
      format.html { redirect_to @answer.question, alert: 'Not allowed.' }
      format.js { head :forbidden }
    end
  end
end
