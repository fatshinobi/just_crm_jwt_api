class ClientAttachmentElementResource < BaseResource
  attributes :id, :description, :attachment_type

  attribute :customer_id do |attachment|
    attachment.attachable_id
  end

  attribute :uploaded_file_name do |attachment|
    attachment.uploaded_file.filename.to_s if attachment.uploaded_file.attached?
  end

  attribute :uploaded_file_url do |attachment|
    Rails.application.routes.url_helpers.rails_blob_url(attachment.uploaded_file, only_path: true) if attachment.uploaded_file.attached?
  end
end
