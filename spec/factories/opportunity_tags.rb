FactoryBot.define do
  factory :opportunity_tag do
    association :opportunity
    association :tag
  end
end
