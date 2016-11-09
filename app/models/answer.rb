class Answer < ApplicationRecord
  validates_presence_of :body
  validates_presence_of :question
  belongs_to :question
end