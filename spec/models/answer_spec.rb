require 'rails_helper'

describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of(:question).with_message(:required) }
  it { should belong_to :question }
end