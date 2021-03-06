require "application_responder"

class ApplicationController < ActionController::Base
  before_action :set_gon_user, unless: :devise_controller?
  skip_authorization_check :root_url

  protect_from_forgery with: :exception

  self.responder = ApplicationResponder
  respond_to :html
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, notice: exception.message }
      format.json { render json: { error: 'You are not authorized to perform
        requested action' }.to_json, status: :forbidden }

      format.js   { head :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def set_gon_user
    gon.user_id = current_user.id if current_user
  end
end
