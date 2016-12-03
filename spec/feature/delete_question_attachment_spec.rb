require_relative 'feature_helper'

feature 'Deleting question attachment' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question_with_attachments, user: user) }
  given!(:question_not_owned_by_user) { create(:question_with_attachments) }

  scenario 'Guest user cannot delete attachment' do
    visit question_path(question)

    within '.attachments' do
      expect(page).not_to have_link('Delete')
    end
  end

  context 'Authenticated user' do
    background { sign_in(user) }

    scenario 'deletes attachment for his own question', :js do
      attachment_file_name = question.attachments.first.file.identifier
      visit question_path(question)

      expect(page).to have_content(attachment_file_name)

      within '.attachments' do
        click_on 'Delete'
      end

      expect(page).not_to have_content(attachment_file_name)
    end

    scenario 'cannot delete other user\'s question attachment' do
      visit question_path(question_not_owned_by_user)

      within '.attachments' do
        expect(page).not_to have_link('Delete')
      end
    end
  end
end
