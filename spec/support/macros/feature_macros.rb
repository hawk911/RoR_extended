module FeatureMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in I18n.t('activerecord.attributes.user.password'), with: '12345678'
    click_on I18n.t('devise.shared.links.login')
  end
end
