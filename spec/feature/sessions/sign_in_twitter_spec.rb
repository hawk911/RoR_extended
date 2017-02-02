require_relative '../feature_helper'

feature 'Signing in using Twitter account',
"I want authorization like user twitter." do

  background { visit new_user_session_path }

  scenario "Twitter(without email) user tries to sign in, log out and sign in again" do
    mock_auth_twitter_without_email
    clear_emails
    click_link 'Sign in with Twitter'

    fill_in 'email', with: 'test@example.com'
    click_button 'Save E-mail'

    within '.notice' do
      expect(page).to have_content I18n.t('devise.registrations.user.send_instructions')
    end
    open_email('test@example.com')
    current_email.click_link 'Confirm my account'

    within '.notice' do
      expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'Twitter')
    end
    click_on I18n.t('layouts.application.signOut')

    within '.notice' do
      expect(page).to have_content I18n.t('devise.sessions.signed_out')
    end
    visit user_twitter_omniauth_authorize_path

    within '.notice' do
      expect(page).to have_content I18n.t('devise.omniauth_callbacks.success',kind: 'Twitter')
    end
  end

  scenario "Twitter(with email) user tries to sign in" do
    mock_auth_twitter_with_email
    click_link 'Sign in with Twitter'

    within '.notice' do
      expect(page).to have_content I18n.t('devise.omniauth_callbacks.success',kind: 'Twitter')
    end
  end

  scenario "Twitter user tries to sign in with invalid credentials" do
    mock_auth_twitter_invalid
    click_link 'Sign in with Twitter'
    within '.notice' do
      expect(page).to have_content I18n.t('devise.omniauth_callbacks.failure', kind:'Oauth provider',
                                          reason: I18n.t('errors.messages.oauth') )
    end
  end
end
