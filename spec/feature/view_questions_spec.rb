require 'rails_helper'

feature 'User can view list of questions' do
  given!(:questions) { create_list(:question, 3) }

  scenario 'view questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end