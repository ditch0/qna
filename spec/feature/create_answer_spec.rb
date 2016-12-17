require_relative 'feature_helper'

feature 'User can answer a question' do
  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  scenario 'authorized user creates answer', js: true do
    sign_in user
    visit question_path(question)
    fill_in 'Your answer', with: 'My answer'
    click_on 'Submit'

    expect(page).to have_current_path(question_path(question))
    within '.answers-block' do
      expect(page).to have_content('My answer')
    end
    expect(find_field('Your answer')).to have_attributes(value: '')
  end

  scenario 'unauthorized user cannot see answer form' do
    visit question_path(question)

    expect(page).not_to have_field('Your answer')
    expect(page).not_to have_button('Submit')
  end

  scenario "user creates an answer and it immediately appears on other user's page", :js do
    Capybara.using_session('user who is expected to see new answer') do
      visit question_path(question)
    end

    Capybara.using_session('user who creates answer') do
      sign_in user
      visit question_path(question)
      fill_in 'Your answer', with: 'My answer'
      click_on 'Submit'
    end

    Capybara.using_session('user who is expected to see new answer') do
      within '.answers-block' do
        expect(page).to have_content('My answer')
      end
    end
  end

  scenario "user fails to create an answer and it does not appear on other user's page", :js do
    Capybara.using_session('user who is expected not to see new answer') do
      visit question_path(question)
    end

    Capybara.using_session('user who creates answer') do
      sign_in user
      visit question_path(question)
      click_on 'Submit'
    end

    Capybara.using_session('user who is expected not to see new answer') do
      expect(page).not_to have_css('.answer')
    end
  end
end
