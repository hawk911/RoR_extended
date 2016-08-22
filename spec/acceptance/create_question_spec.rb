require "rails_helper"

feature 'Create Question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  scenario 'Authenticated user create question' do
    User.create!(email: 'b@test.com', password: '12345678')
    visit new_user_session_path
    fill_in 'Email', with: 'b@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit question_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Body question'
    click_on 'Create'

    expect(page).to have_content 'Question was created'
  end

  scenario 'Non-authenticated user create question' do
    visit question_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
