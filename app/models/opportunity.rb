class Opportunity < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :customer
  belongs_to :user
end
