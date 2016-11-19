require_relative 'feature_helper'

feature 'User registration' do
  given(:user) { attributes_for(:user) }

  scenario 'user registers' do
    visit new_user_registration_path
    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: user[:password]
    fill_in 'Password confirmation', with: user[:password_confirmation]
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
