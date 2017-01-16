require_relative 'feature_helper'

feature 'Commenting' do
  shared_examples_for 'creating comment' do |comments_block_selector|
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    context 'Guest user' do
      scenario 'cannot leave comment' do
        visit question_path(question)

        within comments_block_selector do
          expect(page).not_to have_field('Your comment')
          expect(page).not_to have_button('Submit')
        end
      end
    end

    context 'Authenticated user', :js do
      given!(:user) { create(:user) }

      scenario 'leaves a comment' do
        sign_in user
        visit question_path(question)

        within comments_block_selector do
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

        within comments_block_selector do
          fill_in 'Your comment', with: ''
          click_on 'Submit'

          wait_for_ajax

          expect(page).not_to have_css('.comment')
        end
      end

      scenario "leaves comment and it immediately appears on other user's page" do
        Capybara.using_session('user who is expected to see the comment') do
          visit question_path(question)
        end

        Capybara.using_session('user who comments') do
          sign_in user
          visit question_path(question)

          within comments_block_selector do
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

  context 'answer' do
    it_behaves_like 'creating comment', '.answers-block .comments-block'
  end

  context 'question' do
    it_behaves_like 'creating comment', '.question-block .comments-block'
  end
end
