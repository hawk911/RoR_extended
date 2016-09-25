FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Question #{n} Title" }
    sequence(:body) { |n| "Question #{n} Body" }
    user

    factory :question_with_answers do
      after(:create) do |question|
        create_list(:answer, 2, question: question)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title ''
    body 'MyText'
  end
end
