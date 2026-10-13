FactoryBot.define do
  factory :opportunity do
    title { "New Opportunity" }
    description { "An opportunity description" }
    amount { 5000.00 }
    stage { 0 }
    status { 0 }
    start { Date.new(2024, 1, 1) }
    finish { Date.new(2024, 12, 31) }
    association :customer
    association :user
  end
end
