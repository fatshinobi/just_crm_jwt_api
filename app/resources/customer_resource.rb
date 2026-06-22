class CustomerResource < BaseResource
  include Rails.application.routes.url_helpers
  attributes :id, :name, :about

  attribute :avatar_url do |customer|
    if customer.avatar.attached?
      rails_blob_url(customer.avatar, only_path: false)
    else
      nil
    end
  end
end
