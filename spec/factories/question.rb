FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    sequence(:body)  { |n| "Question text #{n}" }
    user

    factory :question_with_answers do
      transient do
        answers_count 3
      end
      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end

    factory :question_with_attachments do
      transient do
        attachments_count 1
      end
      after(:create) do |question, evaluator|
        create_list(:attachment, evaluator.attachments_count, attachmentable: question)
      end
    end
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
