class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :is_best, :rating
end
