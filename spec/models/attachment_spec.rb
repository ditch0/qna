require 'rails_helper'

describe Attachment, type: :model do
  it { should validate_presence_of :file }
  it { should belong_to(:attachmentable).touch(true) }
end
