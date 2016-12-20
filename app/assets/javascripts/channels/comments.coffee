App.questions = App.cable.subscriptions.create { channel: 'CommentsChannel', question_id: gon.question.id.toString() },
  received: (comment) ->
    $commentsList = if comment.commentable_type == 'Question'
      $('.question-block .comments')
    else
      $("#answer-#{comment.commentable_id} .comments")

    $comment = $('<li>').text(comment.body)
    $commentsList.append($comment)
