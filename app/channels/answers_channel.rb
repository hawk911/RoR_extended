class AnswersChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
  end

  def start_stream_answers(data)
    stream_from "/question/#{data['question_id']}/answers"
  end

end
