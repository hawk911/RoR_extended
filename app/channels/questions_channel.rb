class QuestionsChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    Rails.logger.info "You are disconnected"
  end

  def start_stream
    stream_from '/questions'
  end

end
