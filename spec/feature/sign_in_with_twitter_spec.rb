require_relative 'feature_helper'

feature 'Signing in with Twitter' do
  scenario 'user signs in' do
    visit '/users/sign_in'
    mock_twitter_authorization
    click_on 'Sign in with Twitter'
    fill_in 'Please fill in the email', with: 'user@example.com'
    click_on 'Sign in'

    expect(page).to have_content('Successfully authenticated from Twitter account.')
  end
end
