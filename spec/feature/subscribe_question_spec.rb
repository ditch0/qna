require_relative 'feature_helper'

feature 'Managing question subscriptions' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:followed_question) { create(:question, followers: [user]) }

  scenario 'Guest user cannot manage question subscription' do
    visit question_path(question)

    within '.question-block' do
      expect(page).not_to have_button('Follow')
      expect(page).not_to have_button('Unsubscribe')
    end
  end

  context 'Authenticated user' do
    background { sign_in(user) }

    scenario 'follows question' do
      visit question_path(question)

      within '.question-block' do
        expect(page).not_to have_button('Unsubscribe')
        click_on 'Follow'
      end

      within '.question-block' do
        expect(page).to have_button('Unsubscribe')
        expect(page).not_to have_button('Follow')
      end
    end

    scenario 'unsubscribes question' do
      visit question_path(followed_question)

      within '.question-block' do
        expect(page).not_to have_button('Follow')
        click_on 'Unsubscribe'
      end

      within '.question-block' do
        expect(page).to have_button('Follow')
        expect(page).not_to have_button('Unsubscribe')
      end
    end
  end
end
