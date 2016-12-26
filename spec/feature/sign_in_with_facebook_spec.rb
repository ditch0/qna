require_relative 'feature_helper'

feature 'Signing in with Facebook' do
  scenario 'user signs in' do
    visit '/users/sign_in'
    mock_facebook_authorization
    click_on 'Sign in with Facebook'

    expect(page).to have_content('Successfully authenticated from Facebook account.')
  end
end
