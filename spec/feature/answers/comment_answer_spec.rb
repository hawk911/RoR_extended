require_relative '../feature_helper'

feature 'Add comment for answer', "
I like user
I want add comment for answer" do

  given(:user) { create(:user) }
  given!(:question) { create(:question_with_answers) }

  context 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'add comment', js: true do
      within '.answers' do
        within all('.answer_comments').first do
          fill_in I18n.t('activerecord.attributes.comment.body'), with: 'Body comment first'
          click_on 'Add comment'

          wait_for_ajax

          expect(page).to have_content 'Body comment first'
        end

        within all('.answer_comments').last do
          fill_in I18n.t('activerecord.attributes.comment.body'), with: 'Body comment last'
          click_on 'Add comment'

          wait_for_ajax

          expect(page).to have_content 'Body comment last'
        end
      end
    end
  end
end
