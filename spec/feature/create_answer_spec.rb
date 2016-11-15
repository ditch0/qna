require 'rails_helper'

feature 'User can answer a question' do
  given!(:question) { create(:question) }

  scenario 'create answer' do
    visit question_path(question)
    fill_in 'Your answer', with: 'My answer'
    click_on 'Submit'

    expect(page).to have_current_path(question_path(question))
    expect(page).to have_content('My answer')
  end
end