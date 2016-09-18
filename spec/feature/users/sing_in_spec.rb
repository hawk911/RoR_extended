require "rails_helper"

feature 'User sing in', %q{
  In order to be able to ask question
  as an User
  I want to be able to sing in
} do

  given(:user) {create (:user)}

  scenario 'Registered user try to sing in' do

    sign_in(user)
    within "body" do
      expect(page).to have_content I18n.t('devise.sessions.signed_in')
    end
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sing in' do
    visit new_user_session_path
    fill_in 'Email', with: 'error@test.com'
    fill_in I18n.t('activerecord.attributes.user.password'), with: '12345678'
    click_on I18n.t('devise.shared.links.login')
    save_and_open_page
    within "body" do
      expect(page).to have_content I18n.t('devise.failure.invalid')
    end
    expect(current_path).to eq new_user_session_path
  end


end
