FactoryBot.define do
  factory :authorization do
    user
    provider 'facebook'
    uid '12345678'
  end
end
