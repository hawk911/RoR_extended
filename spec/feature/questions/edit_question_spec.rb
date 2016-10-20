require_relative '../feature_helper'

feature 'User edit question', %q{
  In order to fix mistake
  As owner of question
  I want edit my question
} do

  given(:user) { create(:user) }
  given!(:other_user) { create :user }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'Authenticated User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'show Edit' do
      within '.question' do
        expect(page).to have_content I18n.t('questions.form.edit')
      end
    end

    scenario 'edits with valid attributes', js: true do
      within '.question' do
        click_on I18n.t('questions.form.edit')
        fill_in I18n.t('activerecord.models.question'), with: 'edit question'
        click_on I18n.t('questions.form.edit_save')

        wait_for_ajax

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edit question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits with invalid attributes', js: true do
      within '.question' do
        click_on I18n.t('questions.form.edit')
        expect(page).not_to have_content I18n.t('questions.form.edit')
        fill_in I18n.t('activerecord.models.question'), with: ''
        click_on I18n.t('questions.form.edit_save')

        wait_for_ajax

        expect(page).to_not have_content I18n.t('questions.form.edit')
        expect(page).to have_selector('textarea')
      end
    end
  end

  context 'not owner of the answer' do
    scenario "can't see edit link", js: true do
      sign_in other_user
      visit question_path question

      wait_for_ajax

      within '.question' do
        expect(page).not_to have_selector('textarea')
        expect(page).not_to have_content(I18n.t('questions.form.edit'))
      end
    end
  end

  scenario 'Non-Authenticated User edit', js: true do
    visit question_path(question)

    wait_for_ajax

    expect(page).to_not have_link I18n.t('questions.form.edit')
  end
end
