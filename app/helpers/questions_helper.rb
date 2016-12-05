module QuestionsHelper
  def best_answer_button(answer)
    button_to(
      'Best answer',
      {
        controller: 'answers',
        action: 'set_is_best',
        id: answer.id,
        question_id: answer.question_id
      },
      method: :post,
      remote: true,
      params: { is_best: true },
      class: 'best-answer-button'
    )
  end

  def delete_attachment_link(attachment)
    request_param_name = attachment.attachmentable.class.name.downcase
    path = polymorphic_path(
      attachment.attachmentable,
      request_param_name => { attachments_attributes: { id: attachment.id, _destroy: true } }
    )
    link_to('Delete', path, remote: true, method: :patch)
  end

  def user_is_question_owner?(question)
    user_signed_in? && question.user_id == current_user.id
  end

  def user_is_answer_owner?(answer)
    user_signed_in? && answer.user_id == current_user.id
  end
end
