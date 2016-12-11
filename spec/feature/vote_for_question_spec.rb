require_relative 'feature_helper'

feature 'Voting for question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question_owned_by_user) { create(:question, user: user) }

  scenario 'Guest user cannot vote for question' do
    visit question_path(question)

    within '.question-block' do
      expect(page).not_to have_button('Vote up')
      expect(page).not_to have_button('Vote down')
    end
  end

  context 'Authenticated user' do
    background { sign_in(user) }

    scenario 'votes up', :js do
      visit question_path(question)

      within '.question-block' do
        click_on 'Vote up'

        expect(page.find('.rating')).to have_content('1')
        expect(page).to have_content('You voted up')
        expect(page).not_to have_button('Vote up')
        expect(page).not_to have_button('Vote down')
        expect(page).to have_button('Reset vote')
      end
    end

    scenario 'votes down', :js do
      visit question_path(question)

      within '.question-block' do
        click_on 'Vote down'

        expect(page.find('.rating')).to have_content('-1')
        expect(page).to have_content('You voted down')
        expect(page).not_to have_button('Vote up')
        expect(page).not_to have_button('Vote down')
        expect(page).to have_button('Reset vote')
      end
    end

    scenario 'resets vote', :js do
      visit question_path(question)

      within '.question-block' do
        click_on 'Vote up'
        click_on 'Reset vote'

        expect(page.find('.rating')).to have_content('0')
        expect(page).not_to have_content('You voted')
        expect(page).to have_button('Vote up')
        expect(page).to have_button('Vote down')
        expect(page).not_to have_button('Reset vote')
      end
    end

    scenario 'cannot vote for his own question' do
      visit question_path(question_owned_by_user)

      within '.question-block' do
        expect(page).not_to have_button('Vote up')
        expect(page).not_to have_button('Vote down')
        expect(page).not_to have_button('Reset vote')
      end
    end
  end
end
