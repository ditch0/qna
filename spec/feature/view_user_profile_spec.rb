require_relative 'feature_helper'

feature 'Viewing user profile' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:question_comment) { create(:comment, user: user, commentable: create(:question)) }
  given!(:answer_comment) { create(:comment, user: user, commentable: create(:answer)) }

  scenario 'User views profile page' do
    visit user_path(user)

    expect(page).to have_content(user.email)

    within '.questions' do
      expect(page).to have_link(question.title, href: question_path(question))
      expect(page).to have_content(question.body)
    end

    within '.answers' do
      expect(page).to have_link(answer.question.title, href: question_path(answer.question))
      expect(page).to have_content(answer.body)
    end

    within '.comments' do
      expect(page).to have_link(
        question_comment.commentable.title,
        href: question_path(question_comment.commentable)
      )
      expect(page).to have_content(question_comment.body)

      expect(page).to have_link(
        answer_comment.commentable.question.title,
        href: question_path(answer_comment.commentable.question)
      )
      expect(page).to have_content(answer_comment.body)
    end
  end
end
