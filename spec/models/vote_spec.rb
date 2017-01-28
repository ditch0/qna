require 'rails_helper'

describe Vote, type: :model do
  describe 'relations' do
    it { should belong_to(:votable).touch(true) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:vote, votable: create(:question)) }

    it { should validate_presence_of(:value) }
    it { should validate_inclusion_of(:value).in_array([1, -1]) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:votable_type, :votable_id]) }
  end
end
