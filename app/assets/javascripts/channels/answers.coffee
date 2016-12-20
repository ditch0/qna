#= require_tree ../templates/answers

App.questions = App.cable.subscriptions.create { channel: 'AnswersChannel', question_id: gon.question.id.toString() },
  received: (data) ->
    answerHtml = App.utils.render('answers/answer', answer: data.answer, question: gon.question, attachments: data.attachments)
    $('.answers-block').append(answerHtml)
