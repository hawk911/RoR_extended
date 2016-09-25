FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n} Body" }
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body ''
    question
    user
  end
end
