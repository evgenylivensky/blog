class Comment < ApplicationRecord
  validates_presence_of :post_id, :user_id, :email, :body

  belongs_to :post
  belongs_to :user

  def username
    self.email[0..self.email.index('@')-1]
  end

  def perm_edit?(user)
    if user.present? and user.id == self.user_id
      self.created_at > Time.now - APP_CONFIG.comment_edit_time.minutes
    else
      false
    end
  end
end
