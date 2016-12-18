require_relative '../feature_helper'

feature 'Add comment for question', "
I like user
I want add comment for question" do

  given(:user) { create(:user) }
  context 'Authenticated user' do
    given(:question) { create(:question)}
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'add comment', js:true do
      within '.question_comment' do
        fill_in I18n.t('activerecord.attributes.comment.body'), with: 'Body comment'

        wait_for_ajax

        within '.question_comment' do
          expect(page).to have_content 'Body comment'
        end
      end
    end

  end

end
