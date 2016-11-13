require_relative '../feature_helper'

feature 'Delete files to answer', "
  As author answer with attach files
  I'd like to be able to delete attach files
   " do

  given!(:user) { create(:user) }
  given!(:question) { create(:question_with_answers) }
  given(:other_user) { create(:user) }

  context 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer_body', with: 'answer'
      attach_file 'answer_attachments_attributes_0_file', "#{Rails.root}/spec/spec_helper.rb"
      click_on I18n.t('answers.form.submit')
    end
    scenario 'user delete file', js: true do
      expect(page).to have_link I18n.t('answers.form.delete_file')

      within '.answer' do
        expect(page).to have_link 'rails_helper.rb'
        within '.answer_attachment' do
          click_on I18n.t('answers.form.delete_file')
        end
      end
      wait_for_ajax

      visit question_path(question)

      expect(page).to_not have_link I18n.t('answers.form.delete_file')
      expect(page).to_not have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end
  context 'Other user' do
    background do
      sign_in(other_user)
      visit question_path(question)
    end
    scenario 'cannot delete file', js: true do
      expect(page).to_not have_link I18n.t('answers.form.delete_file')
    end
  end
end
