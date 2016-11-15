require 'rails_helper'

feature 'Sign in' do
  given!(:valid_user) { create(:user) }
  given!(:invalid_user) { build(:user) }

  scenario 'user signs in with valid credentials' do
    sign_in(valid_user)
    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'user signs in with invalid credentials' do
    sign_in(invalid_user)
    expect(page).to have_content('Invalid Email or password.')
  end
end