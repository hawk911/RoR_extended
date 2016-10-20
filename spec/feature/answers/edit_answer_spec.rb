require_relative '../feature_helper'

feature 'User edit answer', '
  In orderto fix mistake
  As owner of answer
  I want edit my answer
' do

  given(:user) { create(:user) }
  given!(:other_user) { create :user }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'show Edit', js: true do
      within '.answers' do
        expect(page).to have_content I18n.t('questions.form.edit')
      end
    end

    scenario 'edits with valid attributes', js: true do
      within '.answers' do
        click_on I18n.t('answers.form.edit')
        fill_in I18n.t('activerecord.models.answer'), with: 'edit answer'
        click_on I18n.t('answers.form.edit_save')

        wait_for_ajax

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edit answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits with invalid attributes', js: true do
      within '.answers' do
        click_on I18n.t('answers.form.edit')
        expect(page).not_to have_content I18n.t('answers.form.edit')
        fill_in I18n.t('activerecord.models.answer'), with: ''
        click_on I18n.t('answers.form.edit_save')

        wait_for_ajax

        expect(page).to_not have_content I18n.t('answers.form.edit')
        expect(page).to have_selector('textarea')
      end
    end
  end

  context 'not owner of the answer', js: true do
    scenario "can't see edit link" do
      sign_in other_user
      visit question_path question

      wait_for_ajax

      within '.answers' do
        expect(page).not_to have_selector('textarea')
        expect(page).not_to have_content(I18n.t('answers.form.edit'))
      end
    end
  end

  scenario 'Non-Authenticated User edit', js: true do
    visit question_path(question)

    expect(page).to_not have_link I18n.t('answers.form.edit')
  end
end
