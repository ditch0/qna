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
end
