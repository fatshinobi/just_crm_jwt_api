class Opportunity < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :customer
  belongs_to :user
  has_many :opportunity_tags
  has_many :tags, through: :opportunity_tags
end
