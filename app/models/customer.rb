class Customer < ApplicationRecord
  has_one_attached :avatar
  belongs_to :user
  has_many :customer_tags
  has_many :tags, through: :customer_tags
end
