class DetailedQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :rating, :attachments, :comments

  def attachments
    object.attachments.map { |a| a.file.url }
  end

  def comments
    object.comments.order(id: :asc)
  end
end
