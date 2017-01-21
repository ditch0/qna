require 'rails_helper'

describe QuestionsMailer do
  describe 'new_answer' do
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer) }
    let!(:mail) { QuestionsMailer.new_answer(user, answer) }

    it 'sets email subject' do
      expect(mail.subject).to eq("New answer for #{answer.question.title}")
    end

    it 'sets email recipient address' do
      expect(mail.to).to eq([user.email])
    end

    it 'sets email sender address' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'includes answer to email' do
      expect(mail.body.encoded).to include(answer.body)
    end
  end
end
