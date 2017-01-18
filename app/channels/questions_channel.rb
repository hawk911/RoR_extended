class QuestionsChannel < ApplicationCable::Channel
  def unsubscribed
    # Rails.logger.info "You are disconnected"
  end

  def start_stream_questions
    stream_from '/questions'
  end
end
