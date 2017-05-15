require_relative 'policy_helper'

describe UserPolicy do
  subject { described_class }

  shared_examples_for 'permissions check' do |context_name, app_user|
    let(:user) { create(:user) }

    context context_name do
      permissions :show? do
        it 'grants access' do
          expect(subject).to permit(app_user, user)
        end
      end

      permissions :index?, :new?, :create?, :edit?, :update?, :destroy? do
        it 'denies access' do
          expect(subject).not_to permit(app_user, user)
        end
      end
    end
  end

  it_behaves_like 'permissions check', 'guest user', nil
  it_behaves_like 'permissions check', 'authorized user', User.new
end
