class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_#{params[:question_id]}" if params[:question_id]
  end
end
