class CustomerTag < ApplicationRecord
  belongs_to :customer
  belongs_to :tag
end
