require 'rails_helper'

describe QuestionFollowersNotificationJob, type: :job do
  let!(:question_follower) { create(:user) }
  let!(:question) { create(:question) }
  let!(:new_answer) { create(:answer, question: question) }
  before { question.followers = [question_follower] }

  it 'calls mailer to create mail' do
    allow(QuestionsMailer).to receive_message_chain(:new_answer, :deliver_later)
    expect(QuestionsMailer).to receive(:new_answer).with(question_follower, new_answer)
    QuestionFollowersNotificationJob.perform_now(new_answer)
  end

  it 'calls mailer to deliver mail' do
    expect(QuestionsMailer).to receive_message_chain(:new_answer, :deliver_later)
    QuestionFollowersNotificationJob.perform_now(new_answer)
  end
end
