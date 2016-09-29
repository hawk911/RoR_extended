require 'rails_helper'

feature 'Destroy answer', '
  Authenticated user can delete
  only your answers
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question_with_answers) }
  given!(:foreign_answer) { question.answers.first }
  context 'valid user destroy answer' do
    before do
      sign_in(user)
      visit question_path(question)
      fill_in I18n.t('activerecord.attributes.answer.body'), with: 'User text answer'
      click_on I18n.t('answers.form.submit')
    end

    scenario 'user create valid answer and delete your answer', js: true do

      wait_for_ajax

      expect(page).to have_content('User text answer')
      within '.answers' do
        click_on I18n.t('activerecord.attributes.answer.delete')
      end

      expect(page).to have_current_path(question_path(question))
      within '.answers' do
        expect(page).not_to have_content('User answer')
        expect(page).not_to have_link(I18n.t('activerecord.attributes.answer.delete'))
      end
    end
  end

  context 'non-Authenticated user destroy answer' do
    scenario 'destroy answer' do
      visit question_path(question)
      within '.answers' do
        expect(page).not_to have_link(I18n.t('activerecord.attributes.answer.delete'))
      end
    end
  end
end
