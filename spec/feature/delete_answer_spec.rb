require 'rails_helper'

feature 'User can delete answer' do
  given!(:user) { create(:user) }
  given!(:own_answer) { create(:answer, user: user) }
  given!(:other_users_answer) { create(:answer) }

  scenario 'authorized user deletes his own answer' do
    sign_in user
    visit question_path(own_answer.question)
    click_on 'Delete answer'

    expect(page).to have_current_path(question_path(own_answer.question))
    expect(page).not_to have_content(own_answer.body)
    expect(page).to have_content('Answer is deleted.')
  end

  scenario 'unauthorized user cannot delete answer' do
    visit question_path(own_answer.question)
    expect(page).not_to have_button('Delete answer')
  end

  scenario 'authorized user cannot delete other users answer' do
    sign_in user

    visit question_path(other_users_answer.question)
    expect(page).not_to have_button('Delete answer')
  end
end
