require_relative '../feature_helper'

feature 'Add files to question', %q{
  As author question
  I'd like to be able to attach files
  For illustrate
  } do

context 'Authenticated user' do
  given(:user) { create(:user) }

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

    within(".question") do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end

  end

  scenario 'user create invalid question with file' do

  end

  scenario 'user delete file' do

  end
end

context 'No-Authenticated user' do
  scenario 'create valid question with file' do

  end
end

end
