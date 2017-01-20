require 'rails_helper'

describe DailyMailer do
  describe 'digest' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:mail) { DailyMailer.digest(user, [question]) }

    it 'sets email subject' do
      expect(mail.subject).to eq('New questions')
    end

    it 'sets email recipient address' do
      expect(mail.to).to eq([user.email])
    end

    it 'sets email sender address' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'includes question to email' do
      expect(mail.body.encoded).to include(question.title)
      expect(mail.body.encoded).to include(question.body)
    end
  end
end
