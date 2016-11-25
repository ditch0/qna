require 'rails_helper'

describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:best_answer).class_name('Answer') }

  it 'should save best answer belonging to the question' do
    question = create(:question_with_answers)
    best_answer = question.answers.first
    question.best_answer = best_answer
    saved = question.save
    question.reload

    expect(saved).to be_truthy
    expect(question.best_answer_id).to eq(best_answer.id)
  end

  it 'should not save best answer belonging to another question' do
    question = create(:question_with_answers)
    best_answer = create(:answer)
    question.best_answer = best_answer
    saved = question.save
    question.reload

    expect(saved).to be_falsey
    expect(question.best_answer_id).to be_nil
  end
end
