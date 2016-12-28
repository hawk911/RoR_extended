FactoryGirl.define do
  factory :comment do
    user
    sequence(:body) { |n| "Comment - #{n}" }
  end
end
