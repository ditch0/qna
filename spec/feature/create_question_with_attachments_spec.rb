require_relative 'feature_helper'

feature 'Creating question with attachment' do
  given!(:user) { create(:user) }
  background { sign_in(user) }

  scenario 'User creates question with attachments' do
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Text',  with: 'Question text'
    attach_file 'File', "#{Rails.root}/Gemfile"
    click_on 'Create'

    visit question_path(user.questions.first)
    expect(page).to have_link 'Gemfile', href: '/uploads/Gemfile'
  end
end
