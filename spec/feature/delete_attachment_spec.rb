require_relative 'feature_helper'

feature 'Deleting attachment' do
  shared_examples_for 'deleting attachment' do |attachmentable_factory|
    given!(:user) { create(:user) }
    given!(:attachmentable) { create(attachmentable_factory, user: user) }
    given!(:attachmentable_by_other_user) { create(attachmentable_factory) }

    def question_page_path(attachmentable)
      question = attachmentable.is_a?(Question) ? attachmentable : attachmentable.question
      question_path(question)
    end

    scenario 'Guest user cannot delete attachment' do
      visit question_page_path(attachmentable)

      within '.attachments' do
        expect(page).not_to have_link('Delete')
      end
    end

    context 'Authenticated user' do
      background { sign_in(user) }

      scenario 'deletes attachment for his own post', :js do
        attachment_file_name = attachmentable.attachments.first.file.identifier
        visit question_page_path(attachmentable)

        expect(page).to have_content(attachment_file_name)

        within '.attachments' do
          click_on 'Delete'
        end

        expect(page).not_to have_content(attachment_file_name)
      end

      scenario 'cannot delete other user\'s post attachment' do
        visit question_page_path(attachmentable_by_other_user)

        within '.attachments' do
          expect(page).not_to have_link('Delete')
        end
      end
    end
  end

  context 'for answer' do
    it_behaves_like 'deleting attachment', :answer_with_attachments
  end

  context 'for question' do
    it_behaves_like 'deleting attachment', :question_with_attachments
  end
end
