class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  has_one_attached :uploaded_file
end
