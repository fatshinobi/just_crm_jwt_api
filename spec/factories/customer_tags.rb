FactoryBot.define do
  factory :customer_tag do
    association :customer
    association :tag
  end
end
