class Client < ApplicationRecord
  has_one_attached :avatar
  belongs_to :user
  has_many :client_tags
end
