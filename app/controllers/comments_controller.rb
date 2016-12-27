class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create]
  after_action :publish_comment, only: [:create]

  authorize_resource

  respond_to :js

  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
    respond_with @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    parent_resource_name = request.path.match(%r{/(.+?)/}).captures.first
    klass_name = parent_resource_name.singularize.camelize
    id_param_name = "#{parent_resource_name.singularize}_id"
    @commentable = klass_name.constantize.find(params[id_param_name])
  end

  def publish_comment
    return unless @comment.persisted?
    question_id = find_question_id
    ActionCable.server.broadcast "comments_#{question_id}", @comment
  end

  def find_question_id
    case @commentable
    when Question
      @commentable.id
    when Answer
      @commentable.question_id
    else
      raise Exception, 'Unsupported commentable type, cannot find question id'
    end
  end
end
