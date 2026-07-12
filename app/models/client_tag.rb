class ClientTag < ApplicationRecord
  belongs_to :client
  belongs_to :tag
end
