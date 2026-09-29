FactoryBot.define do
  factory :customer do
    name { "Test Company" }
    email { "company@example.com" }
    phone { "555-1234" }
    address { "123 Business St" }
    about { "A test customer company" }
    association :user
  end
end
