require "rails_helper"

feature 'Show list question', %q{
  Guest or User see questions
} do

  let!(:questions) {create_list(:question,3)}

  scenario 'Authenticated user show questions list' do
    User.create!(email: 'b@test.com', password: '12345678')
    visit new_user_session_path
    fill_in 'Email', with: 'b@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'

    visit questions_path

    questions.each do |question|
      expect(page).to have_link(question.title)
    end
    save_and_open_page

  end
end
