require 'rails_helper'

describe QuestionFollowersNotificationJob, type: :job do
  before { Question.skip_callback(:create, :after, :add_user_to_followers) }
  after  { Question.set_callback(:create, :after, :add_user_to_followers) }

  let!(:question_follower) { create(:user) }
  let!(:question) { create(:question, followers: [question_follower]) }
  let!(:new_answer) { create(:answer, question: question) }

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
