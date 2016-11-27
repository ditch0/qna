require_relative 'feature_helper'
require 'orderly'

feature 'Choosing best answer' do
  context 'Guest user' do
    given!(:question) { create(:question_with_answers) }

    scenario 'cannot set best answer' do
      visit question_path(question)
      expect(page).not_to have_button('Best answer')
    end
  end

  context 'Authenticated user' do
    given!(:user) { create(:user) }
    background { sign_in(user) }

    context 'who is not the question author' do
      given!(:question) { create(:question_with_answers) }

      scenario 'cannot set best answer' do
        visit question_path(question)
        expect(page).not_to have_button('Best answer')
      end
    end

    context 'who asked the question', js: true do
      given!(:question) { create(:question_with_answers, answers_count: 3, user: user) }
      given(:answers) { question.answers.order(id: :desc) }

      scenario 'can set best answer' do
        visit question_path(question)

        expect(page).to have_button('Best answer', count: question.answers.count)
        expect(answers.first.body).to appear_before(answers.second.body)
        expect(answers.second.body).to appear_before(answers.third.body)

        all('.best-answer-button').last.click
        wait_for_ajax

        expect(answers.third.body).to appear_before(answers.first.body)
        expect(answers.first.body).to appear_before(answers.second.body)
      end

      scenario 'can change best answer' do
        visit question_path(question)
        all('.best-answer-button').last.click
        wait_for_ajax
        all('.best-answer-button').last.click
        wait_for_ajax

        expect(answers.second.body).to appear_before(answers.first.body)
        expect(answers.first.body).to appear_before(answers.third.body)
      end
    end
  end
end
