App.questions = App.cable.subscriptions.create 'QuestionsChannel',
  received: (data) ->
    $('.questions-list').append(data)
