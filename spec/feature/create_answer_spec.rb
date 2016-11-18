require 'rails_helper'

feature 'User can answer a question' do
  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  scenario 'authorized user creates answer' do
    sign_in user
    visit question_path(question)
    fill_in 'Your answer', with: 'My answer'
    click_on 'Submit'

    expect(page).to have_current_path(question_path(question))
    expect(page).to have_content('My answer')
  end

  scenario 'unauthorized user cannot see answer form' do
    visit question_path(question)

    expect(page).not_to have_field('My answer')
    expect(page).not_to have_button('Submit')
  end
end