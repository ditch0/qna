require_relative 'feature_helper'

feature 'Voting' do
  shared_examples_for 'voting' do |votable_factory, votable_block_selector|
    given!(:user) { create(:user) }
    given!(:votable) { create(votable_factory) }
    given!(:votable_owned_by_user) { create(votable_factory, user: user) }
    
    def question_page_path(votable)
      question = votable.is_a?(Question) ? votable : votable.question
      question_path(question)
    end

    scenario 'Guest user cannot vote' do
      visit question_page_path(votable)

      within votable_block_selector do
        expect(page).not_to have_button('Vote up')
        expect(page).not_to have_button('Vote down')
      end
    end

    context 'Authenticated user' do
      background { sign_in(user) }

      scenario 'votes up', :js do
        visit question_page_path(votable)

        within votable_block_selector do
          click_on 'Vote up'

          expect(page.find('.rating')).to have_content('1')
          expect(page).to have_content('You voted up')
          expect(page).not_to have_button('Vote up')
          expect(page).not_to have_button('Vote down')
          expect(page).to have_button('Reset vote')
        end
      end

      scenario 'votes down', :js do
        visit question_page_path(votable)

        within votable_block_selector do
          click_on 'Vote down'

          expect(page.find('.rating')).to have_content('-1')
          expect(page).to have_content('You voted down')
          expect(page).not_to have_button('Vote up')
          expect(page).not_to have_button('Vote down')
          expect(page).to have_button('Reset vote')
        end
      end

      scenario 'resets vote', :js do
        visit question_page_path(votable)

        within votable_block_selector do
          click_on 'Vote up'
          click_on 'Reset vote'

          expect(page.find('.rating')).to have_content('0')
          expect(page).not_to have_content('You voted')
          expect(page).to have_button('Vote up')
          expect(page).to have_button('Vote down')
          expect(page).not_to have_button('Reset vote')
        end
      end

      scenario 'cannot vote for his own post' do
        visit question_page_path(votable_owned_by_user)

        within votable_block_selector do
          expect(page).not_to have_button('Vote up')
          expect(page).not_to have_button('Vote down')
          expect(page).not_to have_button('Reset vote')
        end
      end
    end
  end

  context 'answer' do
    it_behaves_like 'voting', :answer, '.answers-block'
  end

  context 'question' do
    it_behaves_like 'voting', :question, '.question-block'
  end
end
