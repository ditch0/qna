require 'rails_helper'

feature 'User can delete question' do
  given!(:user) { create(:user) }
  given!(:own_question) { create(:question, user: user) }
  given!(:other_users_question) { create(:question, user: create(:user)) }

  scenario 'authorized user deletes his own question' do
    sign_in user
    visit question_path(own_question)
    click_on 'Delete question'

    expect(page).to have_current_path(questions_path)
    expect(page).not_to have_content(own_question.title)
    expect(page).to have_content('Question is deleted.')
  end

  scenario 'unauthorized user cannot delete question' do
    visit question_path(own_question)
    expect(page).not_to have_button('Delete question')
    end

  scenario 'authorized user cannot delete other users question' do
    visit question_path(other_users_question)
    expect(page).not_to have_button('Delete question')
  end
end