require_relative 'feature_helper'

feature 'Commenting question' do
  given!(:question) { create(:question) }

  context 'Guest user' do
    scenario 'cannot comment a question' do
      visit question_path(question)

      within '.question-block .comments-block' do
        expect(page).not_to have_field('Your comment')
        expect(page).not_to have_button('Submit')
      end
    end
  end

  context 'Authenticated user', :js do
    given!(:user) { create(:user) }

    scenario 'comments a question' do
      sign_in user
      visit question_path(question)

      within '.question-block .comments-block' do
        fill_in 'Your comment', with: 'My comment'
        click_on 'Submit'

        wait_for_ajax

        expect(page).to have_content('My comment')
        expect(find_field('Your comment')).to have_attributes(value: '')
      end
    end

    scenario 'cannot save invalid comment' do
      sign_in user
      visit question_path(question)

      within '.question-block .comments-block' do
        fill_in 'Your comment', with: ''
        click_on 'Submit'

        wait_for_ajax

        expect(page).not_to have_css('.comment')
      end
    end

    scenario "comments a question and comment immediately appears on other user's page" do
      Capybara.using_session('user who is expected to see the comment') do
        visit question_path(question)
      end

      Capybara.using_session('user who comments') do
        sign_in user
        visit question_path(question)

        within '.question-block .comments-block' do
          fill_in 'Your comment', with: 'My comment'
          click_on 'Submit'
        end
      end

      Capybara.using_session('user who is expected to see the comment') do
        expect(page).to have_content('My comment')
      end
    end
  end
end
