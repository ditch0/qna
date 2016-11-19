require_relative 'feature_helper'

feature 'Sign out' do
  given!(:user) { create(:user) }
  background { sign_in user }

  scenario 'user signs out' do
    click_on 'Sign out'
    expect(page).to have_content('Signed out successfully.')
  end
end
