require_relative '../feature_helper'

feature 'Add files to answer', %q{
  As author answer
  I'd like to be able to attach files
  For illustrate
  } do

context 'Authenticated user' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user)}

  background do
    sign_in(user)
    visit question_path(question)
  end
  scenario 'user create valid answer with file', js: true do
    fill_in I18n.t('activerecord.attributes.answer.body'), with: 'text answer'
    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on I18n.t('answers.form.submit')
    save_and_open_page
    within(".answer") do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

  end

  scenario 'user create invalid answer with file', js: true do
  	fill_in I18n.t('activerecord.attributes.answer.body'), with: ''
    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on I18n.t('answers.form.submit')
    save_and_open_page
  end

  scenario 'user delete file' do

  end
end

context 'No-Authenticated user' do
  scenario 'create valid answer with file' do

  end
end

end
