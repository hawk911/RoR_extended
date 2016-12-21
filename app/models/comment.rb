class Comment < ApplicationRecord
  after_create :actioncable_commentable
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, :body, presence: true

  def actioncable_commentable
    return if errors.any?
    #binding.pry
    commentable_id = (commentable_type == 'Question') ? commentable_id : commentable.question_id

    ActionCable.server.broadcast(
      "comments_#{commentable_type}_#{commentable_id}",
      commentable_id:   commentable_id,
      commentable_type: commentable_type.underscore,
      comment:          self
    )

    #ActionCable.server.broadcast "answers_question_#{question.id}",
    #ApplicationController.render(
    #  partial: 'comments/comment',
    #  locals: { comment: self }
    #)
  end


end
