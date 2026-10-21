FactoryBot.define do
  factory :client_customer do
    association :client
    association :customer
    role { "Manager" }
  end
end
