FactoryGirl.define do
  factory :answer do
    user
    question
    sequence(:body) { |n| "Answer #{n}" }

    factory :answer_with_attachments do
      transient do
        attachments_count 1
      end
      after(:create) do |answer, evaluator|
        create_list(:attachment, evaluator.attachments_count, attachmentable: answer)
      end
    end
  end

  factory :invalid_answer, class: Answer do
    user
    question
    body nil
  end
end
