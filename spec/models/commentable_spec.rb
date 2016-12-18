require 'rails_helper'

describe Commentable do
  with_model :SomethingCommentable do
    table do |t|
      t.timestamps null: false
    end

    model do
      include Commentable
    end
  end

  subject { SomethingCommentable.new }

  it { should have_many(:comments).dependent(:destroy) }
end
