class ClientAttachmentElementResource < BaseResource
  attributes :id, :description, :attachment_type

  attribute :customer_id do |attachment|
    attachment.attachable_id
  end
end
