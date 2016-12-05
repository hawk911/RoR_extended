class QuestionsChannel < ApplicationCable::Channel
  def do_somethink(data)
    Rails.logger.info data
  end

end
