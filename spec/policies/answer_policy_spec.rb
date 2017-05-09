require_relative 'policy_helper'

describe AnswerPolicy do
  subject { described_class }

  context 'guest user' do
    let(:answer) { create(:answer) }

    permissions :index?, :show? do
      it 'grants access' do
        expect(subject).to permit(nil, answer)
      end
    end

    permissions :new?, :create?, :edit?, :update?, :destroy?, :vote_up?, :vote_down?, :reset_vote?, :set_is_best? do
      it 'denies access' do
        expect(subject).not_to permit(nil, answer)
      end
    end
  end

  context 'authorized user' do
    let(:user) { create(:user) }
    let(:other_users_answer) { create(:answer) }
    let(:answer) { create(:answer, user: user) }
    let(:question) { create(:question, user: user) }
    let(:other_users_question) { create(:question) }

    permissions :index?, :show?, :new?, :create? do
      it 'grants access' do
        expect(subject).to permit(user, answer)
      end
    end

    permissions :edit?, :update?, :destroy? do
      it 'grants access for own answer' do
        expect(subject).to permit(user, answer)
      end

      it 'denies access for answer owned by other user' do
        expect(subject).not_to permit(user, other_users_answer)
      end
    end

    permissions :vote_up?, :vote_down?, :reset_vote? do
      it 'grant access for answer owned by other user' do
        expect(subject).to permit(user, other_users_answer)
      end

      it 'denies access for own answer' do
        expect(subject).not_to permit(user, answer)
      end
    end

    permissions :set_is_best? do
      it 'grants access to question owner' do
        expect(subject).to permit(user, create(:answer, question: question))
      end

      it 'denies access for user who does not own the question' do
        expect(subject).not_to permit(user, create(:answer, question: other_users_question))
      end
    end
  end
end
