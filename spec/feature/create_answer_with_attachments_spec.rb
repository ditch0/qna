require_relative 'feature_helper'

feature 'Creating answer with attachment' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  background { sign_in(user) }

  scenario 'User creates answer with attachments', :js do
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    attach_file 'File', "#{Rails.root}/Gemfile"
    click_on 'Submit'

    expect(page).to have_link 'Gemfile', href: "/uploads/attachment/file/#{Attachment.last.id}/Gemfile"
  end
end
