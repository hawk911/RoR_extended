class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'comments'
  end

  def unsubscribed
    # Rails.logger.info "You are disconnected"
  end
end
