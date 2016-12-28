class DetailedAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :is_best, :rating, :attachments, :comments

  def attachments
    object.attachments.map { |a| a.file.url }
  end

  def comments
    object.comments.order(id: :asc)
  end
end
