class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end

    def failure
      redirect_to root_path
    end
  end

  def twitter
    #render json: request.env['omniauth.auth']
    def twitter
      @user = User.find_for_oauth(request.env["omniauth.auth"])

      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
      else
        session[:new_user_id] = @user.id
        #redirect_to edit_signup_email_path
        redirect_to edit_user_registration
      end
    end

    def failure
      redirect_to root_path
    end

  end
end
