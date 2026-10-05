FactoryBot.define do
  factory :client_tag do
    association :client
    association :tag
  end
end
