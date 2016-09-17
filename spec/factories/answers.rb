FactoryGirl.define do
  factory :answer do
    body "MyText"
    question
    user
  end

  factory :invalid_answer, class: "Answer" do
    body ""
    question
    user
  end

end
