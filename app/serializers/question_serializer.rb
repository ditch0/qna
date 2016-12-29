class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :rating
end
