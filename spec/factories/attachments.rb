FactoryBot.define do
  factory :attachment do
    description { "Test attachment description" }
    attachment_type { 0 }
    association :attachable, factory: :customer
  end
end
