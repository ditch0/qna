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
end
