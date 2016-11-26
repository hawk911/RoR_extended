require 'rails_helper'

feature 'Destroy question', '
  Authenticated user can delete
  only your question
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:user_question_path) { questions_path(question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'valid user destroy question' do
      within '.question_links' do
        click_on I18n.t('activerecord.attributes.question.delete')
      end
      within 'body' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
      end
      expect(page).not_to have_current_path(user_question_path)
    end
  end
end
