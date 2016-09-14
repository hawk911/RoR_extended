require "rails_helper"

feature 'Create Answer', %q{
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  context 'authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end


    scenario 'user create valid answer' do
      save_and_open_page
      fill_in 'Answer', with: 'Text answer'
      click_on 'Post You Answer'

      expect(page).to have_content 'Text answer'

    end
  end

end
