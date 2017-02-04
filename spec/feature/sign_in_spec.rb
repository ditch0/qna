require_relative 'feature_helper'

feature 'Sign in' do
  shared_examples_for 'signing in' do |result_message|
    scenario 'user signs in' do
      visit new_user_session_path
      fill_in 'Email',    with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content(result_message)
    end
  end

  context 'valid user' do
    given!(:user) { create(:user) }
    it_behaves_like 'signing in', 'Signed in successfully.'
  end

  context 'invalid user' do
    given!(:user) { build(:user) }
    it_behaves_like 'signing in', 'Invalid Email or password.'
  end
end
