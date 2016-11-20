require_relative 'feature_helper'

feature 'Question editing' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_not_owned_by_user) { create(:question) }

  scenario 'Guest user cannot edit question' do
    visit questions_path(question)

    expect(page).not_to have_button('Edit question')
  end

  context 'Authenticated user' do
    background { sign_in(user) }

    scenario 'edits his own question', js: true do
      visit question_path(question)
      click_on 'Edit question'
      within '.question-form' do
        fill_in 'Title', with: 'New question title'
        fill_in 'Text', with: 'New question text'
        click_on 'Save'
      end

      within '.question-block' do
        expect(page).to have_content('New question title')
        expect(page).to have_content('New question text')
        expect(page).not_to have_field('Title')
        expect(page).not_to have_field('Text')
      end
    end

    scenario 'edits his own question and clicks edit button again (possible bug)', js: true do
      visit question_path(question)
      click_on 'Edit question'
      within '.question-form' do
        fill_in 'Title', with: 'New question title'
        fill_in 'Text', with: 'New question text'
        click_on 'Save'
      end
      wait_for_ajax
      click_on 'Edit question'

      within '.question-form' do
        expect(find_field('Title').value).to eq('New question title')
        expect(find_field('Text').value).to eq('New question text')
      end
    end

    scenario 'fails to save invalid question', js: true do
      visit question_path(question)
      click_on 'Edit question'
      within '.question-form' do
        fill_in 'Title', with: ''
        fill_in 'Text', with: ''
        click_on 'Save'

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Body can\'t be blank')
      end
    end

    scenario 'cannot edit other user\'s question', js: true do
      visit question_path(question_not_owned_by_user)
      expect(page).not_to have_button('Edit question')
    end
  end
end
