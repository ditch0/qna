class Question < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :body
  has_many :answers
end