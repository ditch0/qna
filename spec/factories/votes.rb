FactoryGirl.define do
  factory :vote do
    value 1
    user
    votable nil
  end
end
