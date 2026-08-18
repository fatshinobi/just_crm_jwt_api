class Appointment < ApplicationRecord
  belongs_to :customer
  belongs_to :client, optional: true
  belongs_to :user
  belongs_to :opportunity, optional: true
end
