FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    user

    factory :question_with_answers do
      after(:create) do |question|
        create_list(:answer,4, question: question)
      end
    end
  end

  factory :invalid_question, class: "Question" do
    title ""
    body "MyText"
  end


end
