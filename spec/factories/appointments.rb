FactoryBot.define do
  factory :appointment do
    about { "Meeting about project" }
    communication_type { 0 }
    status { 0 }
    association :customer
    association :user

    after(:build) do |appointment|
      appointment.when = Time.zone.parse("2024-06-15 10:00:00")
    end
  end
end
