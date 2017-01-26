class OmniauthCallbacksController < Devise::OmniauthCallbacksController

def facebook
  @user = User.find_for_oauth(request.env['omniauth.auth'])
  if @user.persisted?
    sinh_in_and_recirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigation_format?
  end
end

end
