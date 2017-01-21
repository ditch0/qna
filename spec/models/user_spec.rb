require 'rails_helper'

describe User, type: :model do
  describe 'relations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:question_subscriptions).dependent(:destroy) }
    it { should have_many(:followed_questions) }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }

    context 'existing user with existing authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'existing user without authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      it 'does not create new user' do
        expect do
          User.find_for_oauth(auth)
        end.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect do
          User.find_for_oauth(auth)
        end.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'new user' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect do
          User.find_for_oauth(auth)
        end.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'fills user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

    context 'new user without email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {}) }

      it 'does not create new user' do
        expect do
          User.find_for_oauth(auth)
        end.not_to change(User, :count)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'does not create authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to be_empty
      end
    end
  end
end
