class Comment < ApplicationRecord
  after_create :actioncable_commentable
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, :body, presence: true

  def actioncable_commentable
    return if errors.any?

    ActionCable.server.broadcast('comments', self)
  end
end
