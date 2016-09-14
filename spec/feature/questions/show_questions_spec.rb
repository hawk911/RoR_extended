require "rails_helper"

feature 'Show Questions', %q{
  I want to see the questions
  As the registered user
  I want to be able to ask question
} do

  let!(:questions) {create_list(:question,2)}

  scenario "the guest see questions all" do
    visit(questions_path)

    questions.each do |question|
      expect(page).to have_link("question")
    end

  end

end
