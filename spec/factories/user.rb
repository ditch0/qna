FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@somewhere.com" }
    password 'qwerty'
    password_confirmation 'qwerty'
  end
end
