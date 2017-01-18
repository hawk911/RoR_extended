require_relative '../feature_helper'

feature 'Add vote to question', "
  As an authenticated user
  I'd like to be able to vote for question
  For range
  " do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }

  context 'Authenticated user' do
<<<<<<< HEAD
    given(:question) { create(:question, user: other_user) }
=======
    given(:question) { create(:question, user: other_user)}
>>>>>>> 1b85e5a1b3adf3e0c06fbe0cafa926989c608a61
    background do
      sign_in(user)
      visit question_path(question)
    end

<<<<<<< HEAD
    scenario 'like question', js: true do
      within '.question_votes' do
=======
    scenario 'like question', js:true do
      within '.question_votes' do

>>>>>>> 1b85e5a1b3adf3e0c06fbe0cafa926989c608a61
        click_on I18n.t('votes.form.like')

        wait_for_ajax

        expect(page).to_not have_link I18n.t('votes.form.like')
        expect(page).to_not have_link I18n.t('votes.form.dislike')
        expect(page).to have_link I18n.t('votes.form.change')
        expect(page).to have_link I18n.t('votes.form.cancel')

        within('.votable-total') { expect(page).to have_content('1') }
      end
    end

<<<<<<< HEAD
    scenario 'dislike question', js: true do
      within '.question_votes' do
=======
    scenario 'dislike question', js:true do
      within '.question_votes' do

>>>>>>> 1b85e5a1b3adf3e0c06fbe0cafa926989c608a61
        click_on I18n.t('votes.form.dislike')

        wait_for_ajax

        expect(page).to_not have_link I18n.t('votes.form.like')
        expect(page).to_not have_link I18n.t('votes.form.dislike')
        expect(page).to have_link I18n.t('votes.form.change')
        expect(page).to have_link I18n.t('votes.form.cancel')

        within('.votable-total') { expect(page).to have_content('-1') }
      end
    end

<<<<<<< HEAD
    scenario 'change question', js: true do
      within '.question_votes' do
=======
    scenario 'change question', js:true do
      within '.question_votes' do

>>>>>>> 1b85e5a1b3adf3e0c06fbe0cafa926989c608a61
        click_on I18n.t('votes.form.like')
        click_on I18n.t('votes.form.change')

        wait_for_ajax

        expect(page).to_not have_link I18n.t('votes.form.like')
        expect(page).to_not have_link I18n.t('votes.form.dislike')
        expect(page).to have_link I18n.t('votes.form.change')
        expect(page).to have_link I18n.t('votes.form.cancel')

        within('.votable-total') { expect(page).to have_content('-1') }
      end
    end

<<<<<<< HEAD
    scenario 'cancel question', js: true do
      within '.question_votes' do
=======
    scenario 'cancel question', js:true do
      within '.question_votes' do

>>>>>>> 1b85e5a1b3adf3e0c06fbe0cafa926989c608a61
        click_on I18n.t('votes.form.like')
        click_on I18n.t('votes.form.cancel')

        wait_for_ajax

        expect(page).to have_link I18n.t('votes.form.like')
        expect(page).to have_link I18n.t('votes.form.dislike')
        expect(page).to_not have_link I18n.t('votes.form.change')
        expect(page).to_not have_link I18n.t('votes.form.cancel')

        within('.votable-total') { expect(page).to have_content('0') }
      end
    end
<<<<<<< HEAD
=======

>>>>>>> 1b85e5a1b3adf3e0c06fbe0cafa926989c608a61
  end
end
