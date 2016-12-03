require_relative 'feature_helper'

feature 'Creating question with attachment' do
  given!(:user) { create(:user) }
  background { sign_in(user) }

  scenario 'User creates question with attachments', :js do
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Text',  with: 'Question text'
    click_on 'Add attachment'
    attach_file 'File', "#{Rails.root}/Gemfile"
    click_on 'Add attachment'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/README.md"
    end
    click_on 'Create'

    visit question_path(user.questions.first)
    expect(page).to have_link 'Gemfile', href: "/uploads/attachment/file/#{Attachment.first.id}/Gemfile"
    expect(page).to have_link 'README.md', href: "/uploads/attachment/file/#{Attachment.second.id}/README.md"
  end
end
