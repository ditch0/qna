$(document).on 'turbolinks:load', ->
  $('.question-block').on 'click', '.edit-question-button', ->
    $('.question-form').show()
    return

  $('.answers-block').on 'click', '.edit-answer-button', ->
    $(this).closest('.answer').find('.edit-answer-form').show()
    return

  $('.questions-show').on 'ajax:success', '.vote-form', (e, data, status, xhr) ->
    $ratingBlock = $(e.target).closest('.rating-block')
    $ratingBlock.find('.rating').text(data.rating)
    $ratingBlock.toggleClass('voted', data.user_vote != null)
    $ratingBlock.find('.user-vote-info span').text(if data.user_vote == 1 then 'You voted up' else 'You voted down')
    return

  return
