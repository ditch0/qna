require 'rails_helper'

feature 'Sign in' do
  given!(:user) { create(:user) }

  scenario 'user signs in with valid credentials' do
    visit new_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'user signs in with invalid credentials' do
    visit new_session_path
    fill_in 'Email', with: 'does.not.exist@somewhere.com'
    fill_in 'Password', with: 'qwerty'
    click_on 'Sign in'

    expect(page).to have_content('Invalid email or password.')
  end
end