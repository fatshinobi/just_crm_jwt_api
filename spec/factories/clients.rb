FactoryBot.define do
  factory :client do
    name { "Test Client" }
    email { "client@example.com" }
    phone { "555-5678" }
    social { "https://twitter.com/testclient" }
    about { "A test client company" }
    association :user
  end
end
