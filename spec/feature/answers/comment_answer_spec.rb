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
          click_on I18n.t('comments.form.submit')

          wait_for_ajax

          expect(page).to have_content 'Body comment first'
        end

        within all('.answer_comments').last do
          fill_in I18n.t('activerecord.attributes.comment.body'), with: 'Body comment last'
          click_on I18n.t('comments.form.submit')

          wait_for_ajax

          expect(page).to have_content 'Body comment last'
        end
      end
    end
  end

  context "mulitple sessions" do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within all('.answer_comments').first do
          fill_in I18n.t('activerecord.attributes.comment.body'), with: 'My comment for asnwer'
          click_on I18n.t('comments.form.submit')

          wait_for_ajax

          expect(page).not_to have_content 'My comment for asnwer'
        end
      end

      Capybara.using_session('guest') do
        within all('.answer_comments').first do
          expect(page).to have_content 'My comment for asnwer'
        end
      end
    end
  end
end
