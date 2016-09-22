require 'rails_helper'

feature 'Show Question and Answers', '
  I want to see the solution my problem
  As the registered user and
  As the non-registered user (guest)
  I want to see the question and answers to him
' do

  given(:user) { create(:user) }
  given(:question_with_answers) { create(:question_with_answers) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question_with_answers)
    end

    scenario 'the user sees the question and all the answers to it' do
      within '.question' do
        expect(page).to have_content(question_with_answers.body)
        expect(page).to have_content(question_with_answers.title)
      end

      within '.answers' do
        question_with_answers.answers. each do |answer|
          expect(page).to have_content(answer.body)
        end
      end
    end
  end

  context 'non-Authenticated user (guest)' do
    scenario 'the guest sees the question and all the answers to it ' do
      visit question_path(question_with_answers)

      within '.question' do
        expect(page).to have_content(question_with_answers.body)
        expect(page).to have_content(question_with_answers.title)
      end

      within '.answers' do
        question_with_answers.answers. each do |answer|
          expect(page).to have_content(answer.body)
        end
      end
    end
  end
end
