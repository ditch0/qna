include ActionDispatch::TestProcess

FactoryBot.define do
  factory :attachment do
    attachmentable nil
    file { fixture_file_upload('spec/fixtures/uploads/a_file.txt', 'text/plain') }
  end
end
