require 'rails_helper'

feature 'Create Question', '
  In order to get question from community
  As an authenticated user
  I want to be able to ask question
' do

  given(:user) { create(:user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
      click_on I18n.t('questions.index.ask')
      fill_in I18n.t('activerecord.attributes.question.title'), with: 'Test question'
      fill_in I18n.t('activerecord.attributes.question.body'), with: 'Body question'
      click_on I18n.t('questions.form.submit')
    end

    scenario 'user create question' do
      within '.question' do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Body question'
      end
    end

    scenario 'flash user create question' do
      within 'body' do
        expect(page).to have_content I18n.t('flash.success.new_question')
      end
    end
  end

  context 'multiple sessions' do
    scenario "questions appears on another user's page" do
      pry
      Capybara.using_session("user_test") do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session("guest") do
        visit questions_path
      end

      Capybara.using_session("user_test") do
        click_on I18n.t('questions.index.ask')
        fill_in I18n.t('activerecord.attributes.question.title'), with: 'Test question'
        fill_in I18n.t('activerecord.attributes.question.body'), with: 'Body question'
        click_on I18n.t('questions.form.submit')

        within '.question' do
          expect(page).to have_content 'Test question'
          expect(page).to have_content 'Body question'
        end
      end

      Capybara.using_session("guest") do
        expect(page).to have_content 'Test question'
      end
    end
  end

  context 'Authenticated user invalid question' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'user create invalid question' do
      click_on I18n.t('questions.index.ask')
      fill_in I18n.t('activerecord.attributes.question.title'), with: ''
      fill_in I18n.t('activerecord.attributes.question.body'), with: 'Body question'
      click_on I18n.t('questions.form.submit')
      within '.question_errors' do
        expect(page).to have_content (I18n.t('activerecord.attributes.question.title') +
                                      ' ' + I18n.t('errors.messages.blank'))
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'Non-authenticated user create question' do
      visit questions_path
      click_on I18n.t('questions.index.ask')
      within 'body' do
        expect(page).to have_content I18n.t('devise.failure.unauthenticated')
      end
    end
  end
end
