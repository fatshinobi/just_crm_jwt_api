FactoryBot.define do
  factory :tag do
    name { "Active" }
    tag_type { Tag::CUSTOMER_STATUS }
  end
end
