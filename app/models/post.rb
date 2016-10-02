class Post < ApplicationRecord
  validates_presence_of :title
  validates :preview, length: { maximum: 1000 }

  scope :published, ->    { where(published: true) }
  scope :by_owner,  ->(u) { where(user_id: u.id) }
  scope :ordered,   ->    { order(created_at: :desc) }

  has_many :comments, dependent: :destroy

  belongs_to :user

  acts_as_taggable
  acts_as_taggable_on :tags
end
