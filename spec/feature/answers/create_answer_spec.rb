require 'rails_helper'

feature 'Create Answer', '
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answers
' do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
      fill_in I18n.t('activerecord.attributes.answer.body'), with: 'text answer'
      click_on I18n.t('answers.form.submit')
    end

    scenario 'user create valid answer', :aggragate_failures, js: true do
      save_and_open_page
      within '.answers' do
        expect(page).to have_content('text answer')
      end

      within 'body' do
        expect(page).to have_content I18n.t('flash.success.new_answer')
      end
    end

  end

  context 'Authenticated user invalid answer' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'user create invalid answer', js: true do
      fill_in I18n.t('activerecord.attributes.answer.body'), with: ''
      click_on I18n.t('answers.form.submit')
      within '.answer_errors' do
        expect(page).to have_content (I18n.t('activerecord.attributes.answer.body') +
                                      ' ' + I18n.t('errors.messages.blank'))
      end
    end
  end

  context 'non-authenticated user' do
    scenario 'non-authenticated user create answer', js: true do
      visit question_path(question)
      fill_in I18n.t('activerecord.attributes.answer.body'), with: 'text answer'
      click_on I18n.t('answers.form.submit')
      within('body') do
        expect(page).to have_content I18n.t('devise.failure.unauthenticated')
      end
    end
  end
end
