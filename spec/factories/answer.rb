FactoryGirl.define do
  factory :answer do
    question
    sequence(:body) { |n| "Answer #{n}" }
  end

  factory :invalid_answer, class: Answer do
    question
    body nil
  end
end