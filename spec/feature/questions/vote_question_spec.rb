require_relative '../feature_helper'

feature 'Add vote to question', "
  As an authenticated user
  I'd like to be able to vote for question
  For range
  " do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }

  context 'Authenticated user' do
    given(:question) { create(:question, user: other_user)}
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'like question', js:true do
      click_on I18n.t('votes.form.like')

      wait_for_ajax

      expect(page).to_not have_link I18n.t('votes.form.like')
      expect(page).to_not have_link	I18n.t('votes.form.dislike')
      expect(page).to have_link I18n.t('votes.form.change')
      expect(page).to have_link I18n.t('votes.form.cancel')

    end

  end
end
