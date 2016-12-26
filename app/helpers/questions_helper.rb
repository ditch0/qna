module QuestionsHelper
  def best_answer_button(answer)
    button_to(
      'Best answer',
      set_is_best_answer_path(id: answer.id),
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
end
