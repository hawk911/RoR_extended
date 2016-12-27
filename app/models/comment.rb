class Comment < ApplicationRecord
  after_create :actioncable_commentable
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, :body, presence: true

  def actioncable_commentable
    return if errors.any?

    #ActionCable.server.broadcast(
    #  "comments_#{commentable_type}_#{commentable_id}",
    #  commentable_id:   commentable_id,
    #  commentable_type: commentable_type.underscore,
    #  comment:          self
    #)

    ActionCable.server.broadcast channel_path(self),
    ApplicationController.render(
      partial: 'comments/comment',
      locals: { comment: self }
    )
  end

  private

  def channel_path(comment)
    @to_actioncable = "/question/question_#{commentable_id}"
    commentable_type == "Question" ? @path = @to_actioncable : @path = @to_actioncable + '/answers'
    #commentable_type == "Question" ? @path = "/question/question_#{commentable_id}" : @path = "/question/answer_#{commentable_id}/answers"
    @path += "/comments"
    #binding.pry
  end

  #def object_id_for_actioncable
  #  commentable_id = (commentable_type == 'Question') ? commentable_id : commentable.question_id
  #end

end
