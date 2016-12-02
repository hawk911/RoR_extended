require_relative '../feature_helper'

feature 'Add vote to answer', "
  As an authenticated user
  I'd like to be able to vote for answer
  For range
  " do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:answer_user) { create(:user) }

  context 'Authenticated user' do
    given(:question) { create(:question, user: other_user) }
    given!(:answer) { create(:answer, user: answer_user, question: question) }
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'like answer', js:true do
      within '.answer_votes' do
        click_on I18n.t('votes.form.like')

        wait_for_ajax

        expect(page).to_not have_link I18n.t('votes.form.like')
        expect(page).to_not have_link I18n.t('votes.form.dislike')
        expect(page).to have_link I18n.t('votes.form.change')
        expect(page).to have_link I18n.t('votes.form.cancel')

        within('.votable-total') { expect(page).to have_content('1') }
      end
    end

    scenario 'dislike answer', js:true do
      within '.answer_votes' do
        click_on I18n.t('votes.form.dislike')

        wait_for_ajax

        expect(page).to_not have_link I18n.t('votes.form.like')
        expect(page).to_not have_link I18n.t('votes.form.dislike')
        expect(page).to have_link I18n.t('votes.form.change')
        expect(page).to have_link I18n.t('votes.form.cancel')

        within('.votable-total') { expect(page).to have_content('-1') }
      end
    end

    scenario 'change answer', js:true do
      within '.answer_votes' do
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

    scenario 'cancel answer', js:true do
      within '.answer_votes' do
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

  end
end
