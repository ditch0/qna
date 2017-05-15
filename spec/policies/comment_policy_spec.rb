require_relative 'policy_helper'

describe CommentPolicy do
  subject { described_class }

  context 'guest user' do
    let(:comment) { create(:comment) }

    permissions :index?, :show? do
      it 'grants access' do
        expect(subject).to permit(nil, comment)
      end
    end

    permissions :new?, :create?, :edit?, :update?, :destroy? do
      it 'denies access' do
        expect(subject).not_to permit(nil, comment)
      end
    end
  end

  context 'authorized user' do
    let(:user) { create(:user) }
    let(:other_users_comment) { create(:comment) }
    let(:comment) { create(:comment, user: user) }

    permissions :index?, :show?, :new?, :create? do
      it 'grants access' do
        expect(subject).to permit(user, comment)
      end
    end

    permissions :edit?, :update?, :destroy? do
      it 'grants access for own comment' do
        expect(subject).to permit(user, comment)
      end

      it 'denies access for comment owned by other user' do
        expect(subject).not_to permit(user, other_users_comment)
      end
    end
  end
end
