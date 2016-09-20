require "rails_helper"

feature 'Destroy answer', %q{
  Authenticated user can delete
  only your answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) }
  given(:question_path) { "/questions/#{question.id}" }
  given(:foreign_answer_path) { "/answers/#{question.answers.first.id}" }
  context 'valid user destroy answer' do

    before do
      sign_in(user)
      visit question_path
      fill_in I18n.t('activerecord.attributes.answer.body'), with: 'text answer'
      click_on I18n.t('answers.form.submit')
    end

    scenario 'user create valid answer and delete your answer' do
      within ".answers" do
        expect(page).to have_content('text answer')
      end

      expect(page).to have_link(
      I18n.t('activerecord.attributes.answer.delete'), href: "/answers/#{user.answers.last.id}")

      expect(page).not_to have_link(I18n.t('activerecord.attributes.answer.delete'), href: foreign_answer_path)

      click_on I18n.t('activerecord.attributes.answer.delete')

      expect(page).to have_current_path(question_path)

      within ".answers" do
        expect(page).not_to have_content('User answer')
        expect(page).not_to have_link(I18n.t('activerecord.attributes.answer.delete'))
      end
    end
  end
end
