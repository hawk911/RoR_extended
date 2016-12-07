class QuestionsChannel < ApplicationCable::Channel
  def do_somethink(data)
    Rails.logger.info data
  end

  def subscribed
  end

  def unsubscribed
    console.log("You are disconnected")
  end

  def start_stream
    stream_from '/questions'
  end

end
