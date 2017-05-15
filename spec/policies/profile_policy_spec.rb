require_relative 'policy_helper'

describe ProfilePolicy do
  subject { described_class }

  permissions :index?, :me? do
    it 'grants access to authorized user' do
      expect(subject).to permit(create(:user))
    end

    it 'denies access for guest user' do
      expect(subject).not_to permit(nil)
    end
  end
end
