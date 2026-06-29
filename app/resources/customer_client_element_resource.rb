class CustomerClientElementResource < BaseResource
  include Rails.application.routes.url_helpers
  attributes :id, :client_id, :role, :customer_id

  attribute :name do |client_customer|
    client_customer.customer&.name
  end

  attribute :avatar_url do |client_customer|
    if client_customer.customer.avatar.attached?
      rails_blob_url(client_customer.customer.avatar, only_path: false)
    else
      nil
    end
  end
end
