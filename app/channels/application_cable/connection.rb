module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      Rails.logger.info "Reject connection"
    end
  end
end
