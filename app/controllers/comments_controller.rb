class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    respond_with @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    klass = [Question, Answer].detect{|c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

end
