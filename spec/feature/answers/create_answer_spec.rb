require_relative '../feature_helper'

feature 'Create Answer', '
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answers
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
      fill_in I18n.t('activerecord.attributes.answer.body'), with: 'text answer'
      click_on I18n.t('answers.form.submit')
    end

    scenario 'user create valid answer', :aggragate_failures, js: true do
      wait_for_ajax

      expect(page).to have_content('text answer')
      expect(page).to have_current_path(question_path(question))
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

      wait_for_ajax

      expect(page).to have_content (I18n.t('activerecord.attributes.answer.body') +
                                    ' ' + I18n.t('errors.messages.blank'))
    end
  end

  context 'non-authenticated user' do
    scenario 'non-authenticated user create answer', js: true do
      visit question_path(question)
      fill_in I18n.t('activerecord.attributes.answer.body'), with: 'text answer'
      click_on I18n.t('answers.form.submit')

      wait_for_ajax

      expect(page).not_to have_content('text answer')
    end
  end
end
