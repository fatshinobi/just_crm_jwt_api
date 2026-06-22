class CustomerShowResource < BaseResource
  include Rails.application.routes.url_helpers
  attributes :id, :name, :email, :phone, :address, :about, :user_id

  attribute :user_name do |customer|
    customer.user&.name
  end

  attribute :avatar_url do |customer|
    if customer.avatar.attached?
      rails_blob_url(customer.avatar, only_path: false)
    else
      nil
    end
  end
end
