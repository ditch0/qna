require 'rails_helper'

feature 'User can view answers to question' do
  given!(:question) { create(:question_with_answers) }

  scenario 'view question answers' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    question.answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end