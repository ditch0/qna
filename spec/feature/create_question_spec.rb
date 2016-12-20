require_relative 'feature_helper'

feature 'User can create question' do
  given!(:question) { attributes_for(:question) }
  given!(:user) { create(:user) }

  scenario 'authorized user creates question' do
    sign_in user
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: question[:title]
    fill_in 'Text',  with: question[:body]
    click_on 'Create'

    expect(page).to have_current_path(questions_path)
    expect(page).to have_content(question[:title])
  end

  scenario 'unauthorized user is redirected to login page' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  scenario "user creates a question and it immediately appears on other user's page", :js do
    Capybara.using_session('user who creates question') do
      sign_in user
      visit questions_path
      click_on 'Ask question'
    end

    Capybara.using_session('user who is expected to see new question') do
      visit questions_path
    end

    Capybara.using_session('user who creates question') do
      fill_in 'Title', with: question[:title]
      fill_in 'Text',  with: question[:body]
      click_on 'Create'
    end

    Capybara.using_session('user who is expected to see new question') do
      expect(page).to have_content(question[:title])
    end
  end

  scenario "user tries to create invalid question and it does not appear on other user's page", :js do
    Capybara.using_session('user who creates question') do
      sign_in user
      visit questions_path
      click_on 'Ask question'
    end

    Capybara.using_session('user who is expected not to see new question') do
      visit questions_path
    end

    Capybara.using_session('user who creates question') do
      fill_in 'Title', with: question[:title]
      click_on 'Create'
    end

    Capybara.using_session('user who is expected not to see new question') do
      expect(page).not_to have_content(question[:title])
    end
  end
end
