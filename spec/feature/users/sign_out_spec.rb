require 'rails_helper'

feature 'Sign out', '
  I want to get out of the system
' do

  given(:user) { create(:user) }

  scenario 'signed user' do
    sign_in(user)
    visit root_path
    click_on I18n.t('layouts.application.signOut')

    within 'body' do
      expect(page).to have_content(I18n.t('devise.sessions.signed_out'))
    end
    expect(page).to have_current_path(root_path)
    expect(page).not_to have_link I18n.t('layouts.application.signOut')
  end
end
