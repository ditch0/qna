# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('.question-block').on 'click', '.edit-question-button', ->
    $('.question-form').show()
    return

  $('.answers-block').on 'click', '.edit-answer-button', ->
    $(this).closest('.answer').find('.edit-answer-form').show()
    return

  return
