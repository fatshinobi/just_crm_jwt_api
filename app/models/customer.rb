class Customer < ApplicationRecord
  has_one_attached :avatar
  belongs_to :user
  has_many :customer_tags
end
