class Attachment < ApplicationRecord
  validates :file, presence: true

  belongs_to :attachmentable, polymorphic: true, required: false, touch: true

  mount_uploader :file, FileUploader
end
