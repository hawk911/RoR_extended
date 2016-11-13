require_relative '../feature_helper'

feature 'Delete files to question', "
  As author question with attach files
  I'd like to be able to delete attach files
   " do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given!(:question_attachment) { create(:question_attachment, attachable: question) }
  context 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'user delete file', js: true do
      visit question_path(question_attachment.attachable)

      expect(page).to have_link I18n.t('questions.form.delete_file')

      within '.question' do
        expect(page).to have_link 'rails_helper.rb'
        within '.question_attachment' do
          click_on I18n.t('questions.form.delete_file')
        end
      end
      wait_for_ajax

      visit question_path(question_attachment.attachable)

      expect(page).to_not have_link I18n.t('questions.form.delete_file')
      expect(page).to_not have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
  context 'Other user' do
    background do
      sign_in(other_user)
      visit question_path(question_attachment)
    end
    scenario 'cannot delete file', js: true do
      expect(page).to_not have_link I18n.t('questions.form.delete_file')
    end
  end
end
