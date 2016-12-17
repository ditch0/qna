class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_#{params[:question_id]}" if params[:question_id]
  end
end
