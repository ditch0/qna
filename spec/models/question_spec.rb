require 'rails_helper'

describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }
  it { should have_and_belong_to_many(:followers) }

  describe 'subscribing question author to new answers when question is created' do
    let!(:user) { create(:user) }

    it 'adds author to questions followers' do
      question = user.questions.create(attributes_for(:question, user: user))
      expect(question.followers).to include(user)
    end
  end
end
