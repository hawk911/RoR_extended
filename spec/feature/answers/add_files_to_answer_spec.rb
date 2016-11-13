require_relative '../feature_helper'

feature 'Add files to answer', "
  As author answer
  I'd like to be able to attach files
  For illustrate
  " do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  #given(:other_user) { create(:user) }
  #given(:answer_attachment) { create(:answer_attachment, attachable: answer) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'user create valid answer with file', js: true do
      fill_in I18n.t('activerecord.attributes.answer.title'), with: 'text answer'
      within all('.nested-fields').first do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end
      #save_and_open_page
      click_on I18n.t('questions.form.add_file')

      within all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on I18n.t('answers.form.submit')

      wait_for_ajax

      within('.new_answer') do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end

    scenario 'user create invalid answer with file', js: true do
      fill_in I18n.t('activerecord.attributes.answer.body'), with: ''
      within all('.nested-fields').first do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on I18n.t('answers.form.submit')

      wait_for_ajax

      within '.errors' do
        expect(page).to have_content (I18n.t('activerecord.attributes.answer.title') +
                                      ' ' + I18n.t('errors.messages.blank'))
      end
    end
  end

  context 'No-Authenticated user' do
    scenario 'create valid question with file', js: true do
      visit question_path(question)
      save_and_open_page
      within '.new_answer' do
        expect(page).to_not have_link I18n.t('answers.form.add_file')
      end
    end
  end
end
