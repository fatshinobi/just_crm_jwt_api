class Appointment < ApplicationRecord
  acts_as_paranoid
  belongs_to :customer
  belongs_to :client, optional: true
  belongs_to :user
  belongs_to :opportunity, optional: true
end
