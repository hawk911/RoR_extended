require "rails_helper"

feature 'Destroy answer', %q{
  Authenticated user can delete
  only your answers
} do

given(:user) { create(:user) }
given(:other_user) { create(:user) }
given(:question) { create(:question, user: user)}
given(:other_qustion) { create(:question, user: other_user)}
given!(:answer_first){ create(:answer, question: question, user: user) }
given!(:answer_second){ create(:answer, question: question, user: user) }
given!(:other_answer){ create(:answer, question: question, user: other_user) }
  context 'valid user destroy answer' do
    scenario 'onwer user destroy answer' do
      visit root_path
      sign_in(user)
      visit question_path(question)
      click_on 'Удалить вопрос'
      #within ".answer" do
      #  click_on(I18n.t('activerecord.attributes.answer.delete'))
      #end
      save_and_open_page

    end
  end
end
