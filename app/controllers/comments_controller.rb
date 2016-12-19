class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    respond_with @comment
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_votable
    @commentable = controller_name.classify.constantize.find(params[:id])
  end

end
