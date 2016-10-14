require_relative '../feature_helper'

feature 'Best answer', '
I want as owner question
to select the best response
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user)}
  given(:answer_first) { create(:answer, user: user, question: question)}
  given(:answer_second) { create(:answer, user: user, question: question)}

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'not vote answer', js: true do
      wait_for_ajax

      within '.answers' do
        question.answers. each do |answer|
          expect(page).to have_content('Best answer')
        end
        expect(page).to_not have_content('Revert')
      end
    end

    scenario 'vote answer', js: true do
      click_on 'Best answer'

      wait_for_ajax

      within '.answers' do
        expect(page).to have_content('Best answer')
        expect(page).to have_content('Revert')
      end

      #expect(page).to eq(value)
    end

    scenario 'user vote against the aswer', js: true do

    end

  end

  context 'non-Authenticated user' do
    scenario 'not exists votes answer', js: true do

    end

    scenario 'user can not vote for answer', js: true do

    end
  end

end
