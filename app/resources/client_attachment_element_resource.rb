class ClientAttachmentElementResource < BaseResource
  attributes :id, :description, :attachment_type

  attribute :customer_id do |attachment|
    attachment.attachable_id
  end

  attribute :uploaded_file_name do |attachment|
    attachment.uploaded_file.filename.to_s if attachment.uploaded_file.attached?
  end
end
