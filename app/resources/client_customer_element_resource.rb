class ClientCustomerElementResource < BaseResource
  include Rails.application.routes.url_helpers
  attributes :id, :client_id, :role, :customer_id

  attribute :name do |client_customer|
    client_customer.client&.name
  end

  attribute :avatar_url do |client_customer|
    if client_customer.client.avatar.attached?
      rails_blob_url(client_customer.client.avatar, only_path: false)
    else
      nil
    end
  end
end
