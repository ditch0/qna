require_relative 'feature_helper'

feature 'Search' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user) }
  given!(:question_comment) { create(:comment, user: user, commentable: create(:question)) }
  given!(:answer_comment) { create(:comment, user: user, commentable: create(:answer)) }
  given!(:search_results) do
    [
      user,
      question,
      answer,
      question_comment,
      answer_comment
    ]
  end

  scenario 'User does search' do
    allow(ThinkingSphinx).to receive(:search).with(any_args).and_return(search_results)

    visit questions_path
    within '.search' do
      fill_in 'Search', with: 'Anything'
      click_on 'Find'
    end

    expect(page).to have_link(user.email, href: user_path(user.id))

    expect(page).to have_link(question.title, href: question_path(question))
    expect(page).to have_content(question.body)

    expect(page).to have_link(answer.question.title, href: question_path(answer.question))
    expect(page).to have_content(answer.body)

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

  scenario 'User does search with no results' do
    allow(ThinkingSphinx).to receive(:search).with(any_args).and_return([])

    visit questions_path
    within '.search' do
      fill_in 'Search', with: 'Anything'
      click_on 'Find'
    end

    expect(page).to have_content('Nothing is found')
  end
end
