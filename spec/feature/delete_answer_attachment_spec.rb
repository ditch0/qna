require_relative 'feature_helper'

feature 'Deleting answer attachment' do
  given!(:user) { create(:user) }
  given!(:answer) { create(:answer_with_attachments, user: user) }
  given!(:answer_by_other_user) { create(:answer_with_attachments) }

  scenario 'Guest user cannot delete attachment' do
    visit question_path(answer.question)

    within '.attachments' do
      expect(page).not_to have_link('Delete')
    end
  end

  context 'Authenticated user' do
    background { sign_in(user) }

    scenario 'deletes attachment for his own answer', :js do
      attachment_file_name = answer.attachments.first.file.identifier
      visit question_path(answer.question)

      expect(page).to have_content(attachment_file_name)

      within '.attachments' do
        click_on 'Delete'
      end

      expect(page).not_to have_content(attachment_file_name)
    end

    scenario 'cannot delete other user\'s answer attachment' do
      visit question_path(answer_by_other_user.question)

      within '.attachments' do
        expect(page).not_to have_link('Delete')
      end
    end
  end
end
