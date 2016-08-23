module ControllerMacros
  def sign_in_user
    before do
      @user =create(:user)
      @request.env['desive.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end
