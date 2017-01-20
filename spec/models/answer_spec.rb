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
    before { Question.skip_callback(:create, :after, :add_user_to_followers) }
    after  { Question.set_callback(:create, :after, :add_user_to_followers) }

    let!(:user) { create(:user) }
    let!(:question_follower) { create(:user) }
    let!(:question) { create(:question, followers: [question_follower]) }

    it 'calls mailer to create mail when answer is created' do
      allow(QuestionsMailer).to receive_message_chain(:new_answer, :deliver_later)
      answer = question.answers.create(body: 'A new answer', user_id: user.id)
      expect(QuestionsMailer).to have_received(:new_answer).with(question_follower, answer)
    end

    it 'calls mailer to deliver mail' do
      expect(QuestionsMailer).to receive_message_chain(:new_answer, :deliver_later)
      question.answers.create(body: 'A new answer', user_id: user.id)
    end

    it 'does not call mailer to create mail when answer is invalid' do
      question.answers.create(user_id: user.id)
      expect(QuestionsMailer).not_to receive(:new_answer)
    end
  end
end
