module QuestionsHelper
  def best_answer_button(answer)
    button_to(
      'Best answer',
      {
        controller: 'questions',
        action: 'set_best_answer'
      },
      method: :post,
      remote: true,
      params: { answer_id: answer.id },
      class: 'best-answer-button'
    )
  end
end
