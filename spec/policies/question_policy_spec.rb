require_relative 'policy_helper'

describe QuestionPolicy do
  subject { described_class }

  context 'guest user' do
    let(:question) { create(:question) }

    permissions :index?, :show? do
      it 'grants access' do
        expect(subject).to permit(nil, question)
      end
    end

    permissions :new?, :create?, :edit?, :update?, :destroy?, :vote_up?, :vote_down?, :reset_vote? do
      it 'denies access' do
        expect(subject).not_to permit(nil, question)
      end
    end
  end

  context 'authorized user' do
    let(:user) { create(:user) }
    let(:other_users_question) { create(:question) }
    let(:question) do
      question = create(:question, user: user)
      question.followers = []
      question
    end
    let(:followed_question) do
      question = create(:question, user: user)
      question.followers = [user]
      question
    end

    permissions :index?, :show?, :new?, :create? do
      it 'grants access' do
        expect(subject).to permit(user, question)
      end
    end

    permissions :edit?, :update?, :destroy? do
      it 'grants access for own question' do
        expect(subject).to permit(user, question)
      end

      it 'denies access for question owned by other user' do
        expect(subject).not_to permit(user, other_users_question)
      end
    end

    permissions :vote_up?, :vote_down?, :reset_vote? do
      it 'grant access for question owned by other user' do
        expect(subject).to permit(user, other_users_question)
      end

      it 'denies access for own question' do
        expect(subject).not_to permit(user, question)
      end
    end

    permissions :follow? do
      it 'grants access for not followed question' do
        expect(subject).to permit(user, question)
      end

      it 'denies access for followed question' do
        expect(subject).not_to permit(user, followed_question)
      end
    end

    permissions :unsubscribe? do
      it 'grants access for followed question' do
        expect(subject).to permit(user, followed_question)
      end

      it 'denies access for not followed question' do
        expect(subject).not_to permit(user, question)
      end
    end
  end
end
