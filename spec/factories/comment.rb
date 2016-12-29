FactoryGirl.define do
  factory :comment do
    user
    commentable { create(:question) }
    sequence(:body) { |n| "Comment #{n}" }
  end
end
