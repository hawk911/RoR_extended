require 'rails_helper'

feature 'Show list question', '
  I want to see the questions
  As the registered user and
  As the non-registered user (guest)
  I want to be able to ask question
' do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'User show questions list' do
      questions.each do |question|
        expect(page).to have_link(question.title)
      end
    end
  end

  context 'Non-Authenticated user' do
    scenario 'Guest show questions list' do
      visit questions_path
      questions.each do |question|
        expect(page).to have_link(question.title)
      end
    end
  end
end
