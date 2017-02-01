require_relative '../feature_helper'

feature 'Signing in using facebook account',
"I want authorization like user facebook." do

  background { visit new_user_session_path }

  scenario "Facebook user tries to sign in" do
    mock_auth_facebook
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Successfully authenticated from Facebook account')
  end

  scenario "Facebook user tries to sign in with invalid credentials" do
    mock_auth_facebook_invalid
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Could not authenticate you from Facebook because "Credentials are invalid"')
  end
end
