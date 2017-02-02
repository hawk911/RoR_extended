class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :oauth_sign_in

  def facebook
  end

  def twitter
  end

  def failure
    redirect_to root_path
  end

  private

  def oauth_sign_in
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user && @user.persisted?
      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
      else
        session['devise.new_user_id'] = @user.id
        redirect_to edit_signup_email_path
      end
    else
      set_flash_message(:notice, :failure,
                        kind: (auth == nil ? 'Oauth provider' : auth.provider.capitalize),
                        reason: I18n.t('errors.messages.oauth')) if is_navigational_format?
      redirect_to new_user_session_path
    end
  end
end
