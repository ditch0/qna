require_relative 'feature_helper'

feature 'Creating answer with attachment' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  background { sign_in(user) }

  scenario 'User creates answer with attachments', :js do
    visit question_path(question)

    within '.new-answer-form' do
      fill_in 'Your answer', with: 'My answer'
      click_on 'Add attachment'
      attach_file 'File', "#{Rails.root}/Gemfile"
      click_on 'Add attachment'
      within all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/README.md"
      end
      click_on 'Submit'
    end

    expect(page).to have_link 'Gemfile', href: "/uploads/attachment/file/#{Attachment.first.id}/Gemfile"
    expect(page).to have_link 'README.md', href: "/uploads/attachment/file/#{Attachment.second.id}/README.md"
  end
end
