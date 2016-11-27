require_relative 'feature_helper'

feature 'Answer deletion', js: true do
  given!(:user) { create(:user) }
  given!(:own_answer) { create(:answer, user: user) }
  given!(:other_users_answer) { create(:answer) }

  context 'Authenticated user' do
    scenario 'deletes his own answer' do
      sign_in user
      visit question_path(own_answer.question)
      click_on 'Delete answer'

      expect(page).not_to have_content(own_answer.body)
    end

    scenario 'cannot delete other user\'s answer' do
      sign_in user

      visit question_path(other_users_answer.question)
      expect(page).not_to have_button('Delete answer')
    end
  end

  scenario 'Guest user cannot delete answer' do
    visit question_path(own_answer.question)
    expect(page).not_to have_button('Delete answer')
  end
end
