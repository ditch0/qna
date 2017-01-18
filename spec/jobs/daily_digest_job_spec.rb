require 'rails_helper'

describe DailyDigestJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, created_at: Date.yesterday + 1.hour) }

  it 'sends daily digest' do
    expect(DailyMailer).to receive(:digest).exactly(User.count).and_call_original
    DailyDigestJob.perform_now
  end
end
