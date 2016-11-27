require_relative 'feature_helper'

feature 'Answer editing' do
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:answer_by_other_user) { create(:answer) }

  scenario 'Guest user cannot edit answer', js: true do
    visit question_path(answer.question)

    expect(page).to have_content(answer.body)
    expect(page).not_to have_button('Edit answer')
  end

  context 'Authenticated user', js: true do
    background { sign_in(user) }

    scenario 'does not see form for answer editing before clicking edit button' do
      visit question_path(answer.question)

      expect(page).to have_button('Edit answer')
      expect(page).not_to have_css('.edit-answer-form')
    end

    scenario 'edits his own answer' do
      visit question_path(answer.question)
      click_on 'Edit answer'
      within '.edit-answer-form' do
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'
      end

      expect(page).to have_content('Edited answer')
      expect(page).not_to have_content(answer.body)
      expect(page).not_to have_css('.edit-answer-form')
    end

    scenario 'fails to save invalid answer' do
      visit question_path(answer.question)
      click_on 'Edit answer'
      within '.edit-answer-form' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      wait_for_ajax

      expect(page).to have_content(answer.body)
      expect(page).to have_css('.edit-answer-form')
      within '.edit-answer-form' do
        expect(page).to have_content('Body can\'t be blank')
      end
    end

    scenario 'cannot edit other user\'s answer' do
      visit question_path(answer_by_other_user.question)

      expect(page).to have_content(answer_by_other_user.body)
      expect(page).not_to have_button('Edit answer')
    end
  end
end
