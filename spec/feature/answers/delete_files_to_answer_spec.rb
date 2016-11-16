require_relative '../feature_helper'

feature 'Delete files to answer', "
  As author answer with attach files
  I'd like to be able to delete attach files
   " do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:other_user) { create(:user) }

  context 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer_body', with: 'answer'
      within ('.nested-fields') do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on I18n.t('answers.form.submit')
    end

    scenario 'user delete file', js: true do
      expect(page).to have_link I18n.t('answers.form.delete_file')

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb'
        within '.attachments' do
          click_on I18n.t('attachment.form.delete_attach')
        end
      end


      wait_for_ajax

      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link I18n.t('attachment.form.delete_attach')
        expect(page).to_not have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end
  end
  context 'Other user' do
    given!(:attachment) { create(:answer_attachment) }
    given!(:question2) { attachment.attachable.question }

    background do
      sign_in(other_user)
      visit question_path(question2)
    end
    scenario 'cannot delete file', js: true do
      within '.answers'  do
        within('.attachments') do
          expect(page).to_not have_link I18n.t('answers.form.delete_file')
        end
      end
    end
  end
end
