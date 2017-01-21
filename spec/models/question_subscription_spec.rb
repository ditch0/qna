require 'rails_helper'

describe QuestionSubscription, type: :model do
  subject { QuestionSubscription.create(user: create(:user), question: create(:question)) }
  it { should belong_to :user }
  it { should belong_to :question }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
end
