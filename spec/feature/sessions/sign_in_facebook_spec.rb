require_relative '../feature_helper'

feature 'Signing in using facebook account',
"I want authorization like user facebook." do

  background { visit new_user_session_path }

  scenario "Facebook user tries to sign in" do
    mock_auth_facebook
    click_link 'Sign in with Facebook'

    within '.notice' do
      expect(page).to have_content I18n.t('devise.omniauth_callbacks.success',kind: 'Facebook')
    end
  end

  scenario "Facebook user tries to sign in with invalid credentials" do
    mock_auth_facebook_invalid
    click_link 'Sign in with Facebook'

    within '.notice' do
      expect(page).to have_content I18n.t('devise.omniauth_callbacks.failure', kind:'Oauth provider',
                                          reason: I18n.t('errors.messages.oauth') )
    end
  end
end
