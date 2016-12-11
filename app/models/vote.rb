class Vote < ApplicationRecord
  validates :value, presence: true, inclusion: [1, -1]
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }
  belongs_to :user, required: false
  belongs_to :votable, polymorphic: true, required: false
end
