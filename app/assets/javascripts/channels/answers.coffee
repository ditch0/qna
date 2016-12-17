App.questions = App.cable.subscriptions.create { channel: 'AnswersChannel', question_id: gon.question_id.toString() },
  received: (data) ->
    answerId = data.answer_id
    return unless answerId
    $.get "/answers/#{answerId}",
      null,
      (responseHtml) -> $('.answers-block').append(responseHtml)
