class Opportunity < ApplicationRecord
  belongs_to :client
  belongs_to :customer
  belongs_to :user
end
