require 'rails_helper'

feature 'Sign in ', '
  In order to be able ask questions
  As an user
  I want be able to sign up
' do
  context 'valid user' do
    scenario 'new user' do
      visit root_path
      click_on I18n.t('layouts.application.signUp')
      fill_in 'Email', with: 'b@email.com'
      fill_in I18n.t('activerecord.attributes.user.password'), with: '123456'
      fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: '123456'
      click_on I18n.t('devise.registrations.new.signup_btn')

      expect(page).to have_current_path(root_path)
      within 'body' do
        expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
      end
    end

    given(:user) { create(:user) }
    scenario 'signed user, try visit sign up' do
      sign_in(user)
      visit new_user_registration_path

      expect(page).to have_current_path(root_path)
      within 'body' do
        expect(page).to have_content(I18n.t('devise.failure.already_authenticated'))
      end
    end
  end

  context 'invalid user' do
    scenario 'user invalid email' do
      visit root_path
      click_on I18n.t('layouts.application.signUp')
      fill_in 'Email', with: 'bemail.com'
      fill_in I18n.t('activerecord.attributes.user.password'), with: '123456'
      fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: '123456'
      click_on I18n.t('devise.registrations.new.signup_btn')

      within '.new_user' do
        expect(page).to have_content(I18n.t('errors.messages.not_saved.one', resource: I18n.t('activerecord.models.user'), count: 1))
      end
      expect(page).to have_current_path(user_registration_path)
    end

    given(:user) { create(:user) }
    scenario 'email already exists' do
      visit root_path
      click_on I18n.t('layouts.application.signUp')
      fill_in 'Email', with: user.email
      fill_in I18n.t('activerecord.attributes.user.password'), with: '123456'
      fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: '123456'
      click_on I18n.t('devise.registrations.new.signup_btn')

      within '.new_user' do
        expect(page).to have_content(I18n.t('errors.messages.taken'))
      end
    end
  end
end
