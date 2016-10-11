require_relative '../feature_helper'

feature 'User edit question', %q{
  In order to fix mistake
  As owner of question
  I want edit my question
} do

  given(:user) { create(:user) }
  given!(:other_user) { create :user }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'show Edit ' do
      within '.question' do
        expect(page).to have_content 'Edit'
      end
    end

    scenario 'edits with valid attributes', js:true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Question', with: 'edit question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edit question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits with invalid attributes', js:true do
      within '.question' do
        click_on 'Edit'
        expect(page).not_to have_content 'Edit'
        fill_in 'Question', with: ''
        click_on 'Save'

        expect(page).to_not have_content 'Edit'
        expect(page).to have_selector('textarea')
      end
    end
  end

  context 'not owner of the answer' do
    scenario "can't see edit link" do
      sign_in other_user
      visit question_path question

      within '.question' do
        expect(page).not_to have_selector('textarea')
        expect(page).not_to have_content('Edit')
      end
    end
  end


  scenario 'Non-Authenticated User edit' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
