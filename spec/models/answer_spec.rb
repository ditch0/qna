require 'rails_helper'

describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of(:question).with_message(:required) }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }

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

  describe 'notifying questions followers' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    it 'notifies question followers when answer is created' do
      allow(QuestionFollowersNotificationJob).to receive(:perform_later)
      answer = question.answers.create(body: 'A new answer', user_id: user.id)
      expect(QuestionFollowersNotificationJob).to have_received(:perform_later).with(answer)
    end

    it 'does not notify question followers when answer is invalid' do
      expect(QuestionFollowersNotificationJob).not_to receive(:perform_later)
      question.answers.create(user_id: user.id)
    end
  end
end
