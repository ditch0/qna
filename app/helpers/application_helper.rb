module ApplicationHelper
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end

  def comment_question_link(comment)
    question = case comment.commentable
               when Question
                 comment.commentable
               when Answer
                 comment.commentable.question
               else
                 raise Exception, "Unsupported commentable type: #{comment.commentable.class}"
               end
    link_to question.title, question_path(question)
  end

  def collection_cache_key_for(model_type, parent_model = nil)
    klass = model_type.to_s.capitalize.constantize
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    model_key = "#{model_type.to_s.pluralize}/collection-#{klass.count}-#{max_updated_at}"
    return model_key if parent_model.nil?

    parent_model_type = parent_model.class.to_s.underscore
    parent_model_key = "#{parent_model_type.pluralize}/#{parent_model.id}/#{model_key}"
    "#{parent_model_key}/{model_key}"
  end
end
