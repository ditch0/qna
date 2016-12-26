require 'rails_helper'

describe Authorization, type: :model do
  subject { create(:authorization) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:uid) }
end
