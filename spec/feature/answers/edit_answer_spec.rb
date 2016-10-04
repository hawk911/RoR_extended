require_relative '../feature_helper'

feature 'User edit answer', %q{
  In orderto fix mistake
  As owner of answer
  I want edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'show Edit ' do
      within '.answers' do
        expect(page).to have_content 'Edit'
      end

    end

    scenario 'tries to edit the answer', js:true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: "edit answer"
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edit answer'
        expect(page).to_not have_selector 'textarea'
      end

    end

    scenario 'tries to edit other answer' do

    end

  end


  scenario 'Non-Authenticated User edit' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
