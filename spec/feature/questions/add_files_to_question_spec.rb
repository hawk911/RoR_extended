require_relative '../feature_helper'

feature 'Add files to question', "
  As author question
  I'd like to be able to attach files
  For illustrate
  " do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given(:question_attachment) { create(:question_attachment, attachable: question) }
  context 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
    end
    scenario 'user create valid question with file', js: true do
      click_on I18n.t('questions.index.ask')
      fill_in I18n.t('activerecord.attributes.question.title'), with: 'Test question'
      fill_in I18n.t('activerecord.attributes.question.body'), with: 'Body question'

      within all('.nested-fields').first do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end

      click_on I18n.t('questions.form.add_file')

      within all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on I18n.t('questions.form.submit')

      wait_for_ajax

      within('.question') do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end

    scenario 'user create invalid question with file', js: true do
      click_on I18n.t('questions.index.ask')
      fill_in I18n.t('activerecord.attributes.question.title'), with: ''
      fill_in I18n.t('activerecord.attributes.question.body'), with: 'Body question'

      within all('.nested-fields').last do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on I18n.t('questions.form.submit')

      wait_for_ajax

      within '.question_errors' do
        expect(page).to have_content (I18n.t('activerecord.attributes.question.title') +
                                        ' ' + I18n.t('errors.messages.blank'))
      end
    end
  end

  context 'Other user' do
    background do
      sign_in(other_user)
      visit question_path(question_attachment)
    end
    scenario 'can not add file', js: true do
      expect(page).to_not have_link I18n.t('questions.form.add_file')
    end
  end

  context 'No-Authenticated user' do
    scenario 'create valid question with file', js: true do
      visit question_path(question_attachment)
      within '.question' do
        expect(page).to_not have_link I18n.t('questions.form.add_file')
      end
    end
  end
end
