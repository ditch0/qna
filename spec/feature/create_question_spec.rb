require 'rails_helper'

feature 'User can create question' do
  scenario 'create question' do
    question = attributes_for(:question)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question[:title]
    fill_in 'Text',  with: question[:body]
    click_on 'Create'

    expect(page).to have_current_path(questions_path)
    expect(page).to have_content(question[:title])
  end
end