class Api::V1::ProfilesController < Api::V1::BaseController
 authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

 protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def index
    respond_with User.everybody_except_me(current_resource_owner)
  end

end
