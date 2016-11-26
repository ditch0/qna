require 'rails_helper'

describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of(:question).with_message(:required) }
  it { should belong_to :question }
  it { should belong_to :user }

  it 'should set best answer' do
    answer = create(:answer)
    answer.update_is_best(true)
    answer.save
    answer.reload
    expect(answer.is_best).to be_truthy
  end

  it 'should control that only one best answer for question is set' do
    question = create(:question_with_answers, answers_count: 3)
    first_best_answer = question.answers.first
    next_best_answer = question.answers.last

    first_best_answer.update_is_best(true)
    next_best_answer.update_is_best(true)

    first_best_answer.reload
    next_best_answer.reload

    expect(first_best_answer.is_best).to be_falsey
    expect(next_best_answer.is_best).to be_truthy
  end
end
